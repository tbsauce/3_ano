import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spark/main.dart';
import 'colours.dart' as color;
import 'package:spark/models/User.dart' as spark_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/User.dart' as spark_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spark/DatabaseHandler/DbHelper.dart';
import 'package:spark/image_picker.dart' as ImagePicker;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userEmail = "";
  String userName = "";
  String userAge = "";
  String userSeeking = "";
  String userGender = "";
  String description = "";
  String photoURL = "";
  bool isConnected = true;
  DbHelper databaseHelper = DbHelper();
  late Future<spark_user.User> userFuture;
  late String uid;
  var user;

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // Internet connection is available
    } else {
      return false; // No internet connection
    }
  }

  Future<spark_user.User> _getUserFuture(String uid) async {
    final isConnected = await checkInternetConnection();

    if (isConnected) {
      final ref = FirebaseDatabase.instance.ref().child("users");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        for (final key in data.keys) {
          final value = data[key];
          final user = spark_user.User.fromMap(value);
          if (user.ID == uid) {
            return user;
          }
        }
      }
    } else {
      final list = await databaseHelper.getAllUsers();
      if (list.isNotEmpty) {
        final currentUser = list.first;
        uid = currentUser.ID;
        return currentUser;
      }
    }

    throw Exception("User not found in the local database");
  }

  @override
  void initState() {
    super.initState();
    setupUser();
  }

  void setupUser() async {
    isConnected = await checkInternetConnection();
    final currentUser;

    if (isConnected) {
      currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      uid = currentUser!.uid;
    } else {
      final list = await databaseHelper.getAllUsers();
      print(list.toString() + "bbbbbbbbbbbbbbbbbbbbbbbbbbbb Lista");
      if (list.isNotEmpty) {
        currentUser = list.first;
        uid = currentUser.ID;
        currentUser.photoURL = "/assets/images/profiler.png";
      } else {
        currentUser = null;
        uid = "";
      }
    }

    setState(() {
      user =
          currentUser; // Assign the value of currentUser to the user variable
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return FutureBuilder<spark_user.User>(
        future: _getUserFuture(uid),
        builder:
            (BuildContext context, AsyncSnapshot<spark_user.User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: color.colours.primaryBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            userName = user.username;
            userAge = user.age.toString();
            userSeeking = user.seeking;
            userGender = user.gender;
            description = user.description;
            photoURL = user.photoURL;

            return Scaffold(
              backgroundColor: color.colours.primaryBackgroundColor,
              body: SingleChildScrollView(
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
                            const Text(
                              "Perfil",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 30),
                            if (isConnected)
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(photoURL),
                                  radius: 100,
                                ),
                              ),
                            if (!isConnected)
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("/assets/images/profile.png"),
                                  radius: 100,
                                ),
                              ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                userName,
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
                                description,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/editProfile',
                                    arguments: {
                                      'user': user,
                                    },
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(250, 50),
                                  textStyle: const TextStyle(fontSize: 10),
                                  side: const BorderSide(
                                      width: 1.0,
                                      color: color.colours
                                          .primaryColorLight), // Increase the width as desired
                                  foregroundColor:
                                      color.colours.primaryColorLight,
                                ),
                                child: const Text("Editar Perfil"),
                              ),
                            ),
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
                              "User Info",
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
                                  "Sex",
                                  style: TextStyle(
                                    color: color.colours.textColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Text(
                                  userGender,
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
                                  "Seeking",
                                  style: TextStyle(
                                    color: color.colours.textColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Text(
                                  userSeeking,
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
                                  "Age",
                                  style: TextStyle(
                                    color: color.colours.textColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Text(
                                  userAge,
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
                              child: OutlinedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(250, 50),
                                  textStyle: const TextStyle(fontSize: 10),
                                  side: const BorderSide(
                                      width: 1.0,
                                      color: color.colours
                                          .errorColor), // Increase the width as desired
                                  foregroundColor:
                                      color.colours.primaryColorLight,
                                ),
                                child: const Text("Sign Out"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              backgroundColor: color.colours.primaryBackgroundColor,
              body: Center(
                child: Text('Error occurred while loading user data'),
              ),
            );
          }

          return Scaffold(); // Empty scaffold as a fallback
        },
      );
    } else {
      return Scaffold(); // Empty scaffold if no user is logged in
    }
  }
}
