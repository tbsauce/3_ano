import 'package:flutter/material.dart';
import 'package:spark/models/Event.dart';
import 'package:logger/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'colours.dart' as color;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_widget/barcode_widget.dart';

class joinEvent extends StatelessWidget {
  String eventID = "";
  bool isInsideEvent = false;

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

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      eventID = arguments['eventID'];
      isInsideEvent = arguments['isInsideEvent'];
    }

    return Scaffold(
      backgroundColor: color.colours.primaryBackgroundColor,
      body: FutureBuilder<void>(
        future: _getEvent(eventID),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Error occurred while loading event');
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.colours.primaryColor,
                            color.colours.primaryColorDark,
                          ],
                        ),
                        color: color.colours.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          Text(
                            event.eventName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(event.photoURL),
                              radius: 100,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              event.eventName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              event.eventDescription,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          /*if (user != null && user!.uid == event.eventOwner)
                            Align(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/createEvent',
                                    arguments: {
                                      'event': event,
                                    },
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(250, 50),
                                  textStyle: const TextStyle(fontSize: 10),
                                  side: const BorderSide(
                                      width: 1.0,
                                      color: color.colours.primaryColorLight),
                                  foregroundColor:
                                      color.colours.primaryColorLight,
                                ),
                                child: const Text("Editar Evento"),
                              ),
                            ),*/
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Event Info",
                            style: TextStyle(
                              color: color.colours.textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Participants",
                                style: TextStyle(
                                  color: color.colours.textColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                event.totalParticipants.toString(),
                                style: const TextStyle(
                                  color: color.colours.secondaryTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Radius",
                                style: TextStyle(
                                  color: color.colours.textColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                '${event.radius.toString()} Km',
                                style: const TextStyle(
                                  color: color.colours.secondaryTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    if (isInsideEvent) {
                                      if (!event.participants
                                          .contains(user!.uid)) {
                                        event.participants.add(user!.uid);
                                        event.totalParticipants++;
                                      }
                                      final ref =
                                          FirebaseDatabase.instance.ref();
                                      ref
                                          .child('events')
                                          .child(eventID)
                                          .set(event.toMap());
                                      Navigator.pushNamed(context, '/swipe',
                                          arguments: {'eventID': eventID});
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'You need to be inside the event to join it.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(250, 50),
                                    textStyle: const TextStyle(fontSize: 10),
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: color.colours.primaryColorLight,
                                    ),
                                    foregroundColor:
                                        color.colours.primaryColorLight,
                                  ),
                                  child: const Text("Join"),
                                ),
                                const SizedBox(height: 20),
                                BarcodeWidget(
                                  barcode: Barcode.qrCode(),
                                  data: event.ID,
                                  width: 200,
                                  height: 200,
                                ),
                                if (user != null &&
                                    user!.uid == event.eventOwner)
                                  OutlinedButton(
                                    onPressed: () {
                                      final ref =
                                          FirebaseDatabase.instance.ref();
                                      ref
                                          .child('events')
                                          .child(eventID)
                                          .remove()
                                          .then((_) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(250, 50),
                                      textStyle: const TextStyle(fontSize: 10),
                                      side: const BorderSide(
                                        width: 1.0,
                                        color: color.colours.errorColor,
                                      ),
                                      foregroundColor:
                                          color.colours.primaryColorLight,
                                    ),
                                    child: const Text("Delete Event"),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _getEvent(String eventID) async {
    final ref = FirebaseDatabase.instance.ref().child("events");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final eventtmp = Event.fromMap(value);
        if (eventtmp.ID == eventID) {
          event.eventName = eventtmp.eventName;
          event.ID = eventtmp.ID;
          event.eventOwner = eventtmp.eventOwner;
          event.eventDescription = eventtmp.eventDescription;
          event.radius = eventtmp.radius;
          event.latitude = eventtmp.latitude;
          event.longitude = eventtmp.longitude;
          event.totalParticipants = eventtmp.totalParticipants;
          event.participants = eventtmp.participants;
          event.photoURL = eventtmp.photoURL;
        }
      });
    } else {
      Logger().e("No data available.");
    }
  }
}
