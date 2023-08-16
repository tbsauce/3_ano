import 'package:flutter/material.dart';
import 'package:spark/homepage.dart';
import 'package:spark/models/Event.dart';
import 'Screens/EditProfile.dart';
import 'Screens/login.dart';
import 'Screens/profile.dart';
import 'Screens/Swipe.dart';
import 'Screens/maps.dart';
import 'package:logger/logger.dart';
import 'Screens/register.dart';
import 'Screens/joinEvent.dart';
import 'Screens/CreateEvent.dart';
import 'models/QrReader.dart';
import 'package:spark/DatabaseHandler/DbHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
import 'package:firebase_database/firebase_database.dart' show DataSnapshot;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String dbFilePath = '${appDocumentsDirectory.path}/my_database.db';

  if (!await File(dbFilePath).exists()) {
    // Copy the database file if it doesn't exist
    ByteData data = await rootBundle.load('assets/images/my_database.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbFilePath).writeAsBytes(bytes);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  DbHelper databaseHelper = DbHelper();

  Future<void> fetchAndStoreEvents() async {
    final ref = FirebaseDatabase.instance.ref().child("events");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      // Iterate over the events from the Firebase database and insert them into the local database
      Map<dynamic, dynamic> events = snapshot.value as Map<dynamic, dynamic>;
      events.forEach((key, value) async {
        Event event = Event(
          eventName: value['eventName'],
          ID: value['ID'],
          eventOwner: value['eventOwner'],
          eventDescription: value['eventDescription'],
          radius: value['radius'] as int,
          latitude: (value['latitude'] as num).toDouble(),
          longitude: (value['longitude'] as num).toDouble(),
          totalParticipants: value['totalParticipants'] as int,
        );
        await databaseHelper.saveEvent(event);
      });
      final a = await databaseHelper.getAllEvents();
      print(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    databaseHelper.clearUserTable();
    databaseHelper.clearEventTable();
    fetchAndStoreEvents();
    return MaterialApp(
      title: 'Spark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/maps',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/maps': (context) => CommonTabBar(child: const MyMap()),
        '/profile': (context) => CommonTabBar(child: const ProfilePage()),
        '/editProfile': (context) => CommonTabBar(child: const EditProfile()),
        '/joinEvent': (context) => CommonTabBar(child: joinEvent()),
        '/createEvent': (context) => CommonTabBar(child: CreateEvent()),
        '/swipe': (context) => CommonTabBar(child: const Swipe()),
        '/chat': (context) => CommonTabBar(child: const MyHomePage()),
        '/QRreader': (context) => CommonTabBar(child: QRScannerPage()),
      },
    );
  }
}

class CommonTabBar extends StatelessWidget {
  final Widget child;

  CommonTabBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spark'),
          bottom: TabBar(
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/chat');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/maps');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/profile');
                  break;
              }
            },
            indicator: const BoxDecoration(),
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.chat_bubble)),
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: child,
      ),
    );
  }
}
