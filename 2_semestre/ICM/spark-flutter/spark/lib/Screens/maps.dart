import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/Event.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spark/DatabaseHandler/DbHelper.dart';
import 'package:connectivity/connectivity.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MapScreenState();
}

class _MapScreenState extends State<MyMap> {
  late GoogleMapController mapController;
  Position? currentPosition;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  StreamSubscription? positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _checkLocationPermission() async {
    final permissionStatus = await Permission.locationWhenInUse.status;
    if (permissionStatus.isGranted) {
      _getCurrentLocation();
      _subscribeToPositionUpdates();
    } else if (permissionStatus.isDenied) {
      _requestLocationPermission();
    }
  }

  void _requestLocationPermission() async {
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (permissionStatus.isGranted) {
      _getCurrentLocation();
      _subscribeToPositionUpdates();
    }
  }

  void _getCurrentLocation() async {
    final lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (lastKnownPosition != null) {
      _updateMarker(lastKnownPosition);
    }
  }

  void _subscribeToPositionUpdates() {
    positionStreamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        _updateMarker(position);
      },
    );
  }

  void _updateMarker(Position position) {
    setState(() {
      currentPosition = position;
      markers.removeWhere((m) => m.markerId.value == 'currentLocation');
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          //secalhar não e necessario mas para ter a certeza que n se pode clicar no user
          consumeTapEvents: true,
        ),
      );
    });
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // Internet connection is available
    } else {
      return false; // No internet connection
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final isConnected = await checkInternetConnection();

    if (isConnected) {
      mapController = controller;
      final ref = FirebaseDatabase.instance.ref().child("events");

      //initializing all existing events in the database
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final event = Event.fromMap(value);
          createEventMarker(event: event);
        });
      } else {
        Logger().i("No Events available.");
      }

      //Listener to updates in the database of child events
      ref.onValue.listen((event) {
        markers = {};
        circles = {};
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final event = Event.fromMap(value);
          createEventMarker(event: event);
        });
      });
    } else {
      DbHelper databaseHelper = DbHelper();
      final allRows = await databaseHelper.getAllEvents();
      allRows.forEach((row) {
        final event = row;
        createEventMarker(event: event);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition != null
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                zoom: 11.0,
              ),
              markers: markers,
              circles: circles,
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/QRreader",
                arguments: {
                  'userPosition': currentPosition,
                },
              );
            },
            child: const Icon(Icons.qr_code),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/createEvent',
                arguments: {
                  'LatLngUser': currentPosition,
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  //creates markers and circles for the event
  void createEventMarker({required Event event}) {
    var coordinates = LatLng(event.latitude, event.longitude);

    //creates the marker for the event
    final markerEvent = Marker(
      markerId: MarkerId(event.ID),
      position: coordinates,
      infoWindow: InfoWindow(title: event.eventName),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/joinEvent',
          arguments: {
            'eventID': event.ID,
            'isInsideEvent': userInsideEvent(event),
          },
        );
      },
    );

    //creates the circle for the event
    final circleEvent = Circle(
      circleId: CircleId(event.ID),
      center: coordinates,
      radius: event.radius
          .toDouble(), // Assuming radius is in kilometers, convert it to meters
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );

    setState(() {
      markers.add(markerEvent);
      circles.add(circleEvent);
    });
  }

  //returns true if user inside the radius of the event
  bool userInsideEvent(Event event) {
    final double yEvent = event.longitude;
    final double xEvent = event.latitude;
    final double yUser = currentPosition!.longitude;
    final double xUser = currentPosition!.latitude;
    final int radius = event.radius;

    final double distance = Geolocator.distanceBetween(
      xUser,
      yUser,
      xEvent,
      yEvent,
    );
    return radius >= distance;
  }
}
