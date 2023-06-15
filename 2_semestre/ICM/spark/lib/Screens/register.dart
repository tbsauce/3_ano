import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:spark/models/Event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/image_picker.dart';
import 'package:spark/image_picker.dart' show getPhotoURL;
//import 'package:file_picker/file_picker.dart';
import 'package:spark/models/User.dart' as spark_user;
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spark/DatabaseHandler/DbHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spark/models/User.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  int _currentValue = 18;
  int? _selectedGender;
  int? _selectedShow;
  String? _imagePath;
  bool _isButtonEnabled = false;
  String? _selectedGenderTitle;
  String? _selectedShowTitle;
  final DbHelper databaseHelper = DbHelper();
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
  }

  //void _loadImage() async {
  //  final result = await FilePicker.platform.pickFiles();
//
  //  if (result != null) {
  //    setState(() {
  //      _imagePath = result.files.single.path;
  //      _checkButtonEnabled();
  //    });
  //  }
  //}

  void onValueChanged(String newValue) {
    setState(() {
      imageUrl = newValue;
    });
  }

  void _checkButtonEnabled() {
    if (_selectedGender != null && _selectedShow != null) {
      setState(() {
        _isButtonEnabled = true;
        _selectedGenderTitle = _getGenderTitle(_selectedGender!);
        _selectedShowTitle = _getShowTitle(_selectedShow!);
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
        _selectedGenderTitle = null;
        _selectedShowTitle = null;
      });
    }
  }

  String _getGenderTitle(int value) {
    switch (value) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      case 3:
        return 'Other';
      default:
        return '';
    }
  }

  String _getShowTitle(int value) {
    switch (value) {
      case 1:
        return 'Males';
      case 2:
        return 'Females';
      case 3:
        return 'Everyone';
      default:
        return '';
    }
  }

  void _addUser() async {
    String a;
    if (_imagePath == null) {
      a = 'assets/images/placeholder.png';
    } else {
      a = _imagePath!;
    }

    try {
      // Validate email format
      final emailRegex =
          RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
      if (!emailRegex.hasMatch(emailController.text)) {
        // Invalid email format
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Invalid email format.'),
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
        return; // Stop the registration process
      }

      if (passwordController.text.length < 6) {
        // Password length is less than 6 characters
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Password must have at least 6 characters.'),
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
        return; // Stop the registration process
      }

      // Create a new user in Firebase Authentication
      firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the newly created user
      firebase_auth.User? user = userCredential.user;

      if (user != null) {
        final DatabaseReference ref = FirebaseDatabase.instance.ref();
        final _firestore = FirebaseFirestore.instance;

        final data = {
          'id': user.uid,
          'name': usernameController.text,
          'date_time': DateTime.now(),
          'email': emailController.text,
        };
        User usuario = User(
          user.uid,
          emailController.text,
          passwordController.text,
          usernameController.text,
          _currentValue,
          _selectedShowTitle!,
          _selectedGenderTitle!,
        );
        try {
          _firestore.collection('Users').doc(user.uid).set(data);
          databaseHelper.clearUserTable();
          databaseHelper.saveData(usuario);
        } catch (e) {
          print(e);
        }

        final newUser = spark_user.User(
          user.uid,
          emailController.text,
          passwordController.text,
          usernameController.text,
          _currentValue,
          _selectedShowTitle!,
          _selectedGenderTitle!,
          //urlImage: a,
        );
        newUser.photoURL = imageUrl;

        // Push the new user data to the "users" node in the database
        await ref.child('users').child(user.uid).set(newUser.toMap());

        // Navigate to the desired screen after successful registration
        Navigator.pushReplacementNamed(context, '/maps');

        // Reset the form fields and variables
        emailController.clear();
        passwordController.clear();
        usernameController.clear();
        _currentValue = 18;
        _selectedGender = null;
        _selectedShow = null;
        _imagePath = null;
        _isButtonEnabled = false;
      }
    } catch (e) {
      // Handle any errors that occur during registration
      print('Error registering user: $e');

      // Show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'An error occurred during registration. Please try again.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              ImagePickerWidget(onValueChanged: onValueChanged, edit: ""),
              // GestureDetector(
              //  onTap: _loadImage,
              //  child: Container(
              //    width: 200,
              //    height: 200,
              //    color: Colors.grey,
              //    child: _imagePath != null
              //        ? Image.asset(
              //            _imagePath!,
              //            fit: BoxFit.cover,
              //          )
              //        : const Icon(Icons.add),
              //  ),
              //),
              const SizedBox(height: 10.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'username',
                ),
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Age: $_currentValue'),
              ),
              Slider(
                value: _currentValue.toDouble(),
                min: 18,
                max: 100,
                divisions: 100,
                label: _currentValue.toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentValue = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Gender:'),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: const Text('Male'),
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Female'),
                    value: 2,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Other'),
                    value: 3,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Show:'),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: const Text('Males'),
                    value: 1,
                    groupValue: _selectedShow,
                    onChanged: (value) {
                      setState(() {
                        _selectedShow = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Females'),
                    value: 2,
                    groupValue: _selectedShow,
                    onChanged: (value) {
                      setState(() {
                        _selectedShow = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Everyone'),
                    value: 3,
                    groupValue: _selectedShow,
                    onChanged: (value) {
                      setState(() {
                        _selectedShow = value;
                        _checkButtonEnabled();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _addUser : null,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
