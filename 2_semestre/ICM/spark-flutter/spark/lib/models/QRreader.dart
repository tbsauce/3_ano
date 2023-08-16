import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/Event.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Position? userPosition;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      userPosition = arguments['userPosition'];
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller!.scannedDataStream.listen((scanData) {
        _controller!.pauseCamera();
        _getEvent(scanData.code!);
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _getEvent(String eventID) async {
    final ref = FirebaseDatabase.instance.ref().child("events");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final eventtmp = Event.fromMap(value);
        if (eventtmp.ID == eventID) {
          Navigator.pushReplacementNamed(
            context,
            '/joinEvent',
            arguments: {
              'eventID': eventID,
              'isInsideEvent': userInsideEvent(eventtmp),
            },
          );
        }
      });
    } else {
      Logger().e("No data available.");
    }
  }

  //returns true if user inside the radius of the event
  bool userInsideEvent(Event event) {
    final double yEvent = event.longitude;
    final double xEvent = event.latitude;
    final double yUser = userPosition!.longitude;
    final double xUser = userPosition!.latitude;
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
