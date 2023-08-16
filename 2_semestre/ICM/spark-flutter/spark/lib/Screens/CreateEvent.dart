import 'package:flutter/material.dart';
import 'package:spark/image_picker.dart';
import 'colours.dart' as color;
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:spark/models/Event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool init = true;
  String imageUrl = "";


  //for editing the events
  Event event = Event(
    eventName: "",
    ID: "",
    eventOwner: "",
    eventDescription: "",
    radius: 0,
    latitude: 0,
    longitude: 0,
    totalParticipants: 0,
    participants: [],
  );

  String name = '';
  String aboutMe = '';
  int radius = 50;
  Position? userLocation;

  void onValueChanged(String newValue) {
    setState(() {
      imageUrl = newValue;
    });
  }

  void saveChanges() async {
    // add event to database
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Logger().e("No user logged in.");
      return;
    }
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    if (init) {
      String randomKey = ref.push().key!;
      Event event = Event(
        eventName: name,
        ID: randomKey,
        eventOwner: user.uid,
        eventDescription: aboutMe,
        radius: radius * 1000,
        latitude: userLocation!.latitude,
        longitude: userLocation!.longitude,
        totalParticipants: 0,
        participants: [],
      );
      event.photoURL = imageUrl;

      await ref.child('events').child(randomKey).set(event.toMap());
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments['LatLngUser'] != null) {
      userLocation = arguments['LatLngUser'];
    } else if (init && arguments != null && arguments['event'] != null) {
      event = arguments['event'];
      nameController.text = event.eventName;
      descriptionController.text = event.eventDescription;
      radius = event.radius ~/ 1000;
      init = false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: 450,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  color.colours.primaryColor,
                  color.colours.primaryColorDark,
                ]),
                color: color.colours.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                            side: const BorderSide(
                              width: 4,
                              color: Color.fromARGB(100, 142, 69, 75),
                            ),
                          ),
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 50,
                          color: Color.fromARGB(100, 142, 69, 75),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ImagePickerWidget(onValueChanged: onValueChanged, edit: ""),

            // Name
            TextField(
              decoration: const InputDecoration(labelText: 'Event Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              controller: nameController,
            ),
            const SizedBox(height: 8.0),

            TextField(
              decoration: const InputDecoration(labelText: 'Event Description'),
              onChanged: (value) {
                setState(() {
                  aboutMe = value;
                });
              },
              controller: descriptionController,
            ),
            const SizedBox(height: 16.0),

            // Event Radius Slider
            Slider(
              value: radius.toDouble(),
              min: 1,
              max: 100,
              divisions: 100,
              onChanged: (double value) {
                setState(() {
                  radius = value.toInt();
                });
              },
              label: 'Event Radius: $radius',
            ),
            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                saveChanges();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(250, 50),
                textStyle: const TextStyle(fontSize: 10),
                side: const BorderSide(
                  width: 1.0,
                  color: color.colours.primaryColorLight,
                ),
                foregroundColor: color.colours.primaryColorLight,
              ),
              child: const Text(
                "Create Event",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
