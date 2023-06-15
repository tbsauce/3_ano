import 'package:flutter/material.dart';
import '../models/User.dart';
import 'TinderCard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/User.dart' as spark_user;
import 'package:logger/logger.dart';
import 'package:spark/models/Event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class Swipe extends StatefulWidget {
  const Swipe({Key? key}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  List<spark_user.User> users = [];
  int currentIndex = 0;
  bool swipedAll = false;
  late DatabaseReference refEvent;
  String eventID = "";
  spark_user.User currentUser = spark_user.User("", "", "", "", 0, "", "");

  void likedUser() {
    // check if they have a match
    if (users[currentIndex].iLiked.contains(currentUser.ID)) {
      users[currentIndex].matched.add(currentUser.ID);
      currentUser.matched.add(users[currentIndex].ID);

      //eleminate from liked
      users[currentIndex].iLiked.remove(currentUser.ID);
      //making sure the current doesnt have the other in the liked list even tho is very unprobable
      if (currentUser.iLiked.contains(users[currentIndex].ID)) {
        currentUser.iLiked.remove(users[currentIndex].ID);
      }

      // update database
      FirebaseDatabase.instance
          .ref()
          .child("users/${users[currentIndex].ID}")
          .update(users[currentIndex].toMap());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Marched!'),
            content:
                Text('You have matched with ${users[currentIndex].username}!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Continue Swiping!'),
              ),
            ],
          );
        },
      );
    } else {
      if (!currentUser.iLiked.contains(users[currentIndex].ID)) {
        currentUser.iLiked.add(users[currentIndex].ID);
      }
    }

    FirebaseDatabase.instance
        .ref()
        .child("users/${currentUser.ID}")
        .update(currentUser.toMap());
  }

  void nextUser() {
    setState(() {
      if (currentIndex < users.length - 1) {
        currentIndex++;
      } else {
        swipedAll = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void getCurrentuser(String uid) async {
    DatabaseReference refUser =
        FirebaseDatabase.instance.ref().child("users/$uid");
    final snapshot = await refUser.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      currentUser = spark_user.User.fromMap(userData);
      Logger().i(currentUser);
    } else {
      Logger().e("No user found");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      eventID = arguments['eventID'];
      getEventData();
    }

    final firebase_auth.User? userAuth = FirebaseAuth.instance.currentUser;
    getCurrentuser(userAuth!.uid);
  }

  void getEventData() {
    refEvent = FirebaseDatabase.instance.ref().child("events/$eventID");
    refEvent.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final Map<dynamic, dynamic> eventMap = data as Map<dynamic, dynamic>;
        final event = Event.fromMap(eventMap);
        swipedAll = false;
        getUsersData(event.participants);
      } else {
        throw Exception("No event found");
      }
    });
  }

  void getUsersData(List<String> participants) async {
    users.clear(); // clear users
    final DatabaseReference refUser =
        FirebaseDatabase.instance.ref().child("users");
    final snapshot = await refUser.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final key in data.keys) {
        final value = data[key];
        if (participants.contains(key)) {
          final user = spark_user.User.fromMap(value);
          //filtering users
          if (user.ID != currentUser.ID &&
              !currentUser.matched.contains(user.ID) &&
              !currentUser.iLiked.contains(user.ID) &&
              !(currentUser.seeking == "Males" && user.gender != "Male") &&
              !(currentUser.seeking == "Females" && user.gender != "Female")) {
            users.add(user);
          }
        }
      }
      setState(() {});
    } else {
      throw Exception("No user found");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty || swipedAll) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Waiting for more users..."),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(child: TinderCard(user: users[currentIndex])),
                const SizedBox(height: 20),
                buildButtons(),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: nextUser,
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
            child: const Icon(
              Icons.clear,
              color: Colors.red,
              size: 20,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              likedUser();
              nextUser();
            },
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.teal,
              size: 20,
            ),
          ),
        ],
      );
}
