import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:spark/DatabaseHandler/DbHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/User.dart' as spark_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class LoginPage extends StatelessWidget {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final DbHelper databaseHelper = DbHelper();

  Future<spark_user.User> _getUserFuture(String uid) async {
    final ref = FirebaseDatabase.instance.ref().child("users");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final key in data.keys) {
        final value = data[key];
        final user = spark_user.User.fromMap(value);
        if (user.email == uid) {
          return user;
        }
      }
    }
    throw Exception("No user found");
  }

  @override
  Widget build(BuildContext context) {
    databaseHelper.clearUserTable();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/ic_app.png',
              width: 200.0,
              height: 200.0,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final String email = phoneController.text;
                final String password = passwordController.text;
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Log in successful
                  User? user = userCredential.user;

                  if (user != null) {
                    spark_user.User k = await _getUserFuture(email);
                    await databaseHelper.saveData(k);
                    // Navigate to the desired screen after successful login
                    Navigator.pushNamed(context, '/maps');
                  }
                } catch (e) {
                  // Log in failed
                  Logger().e('Error logging in: $e');
                }
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
