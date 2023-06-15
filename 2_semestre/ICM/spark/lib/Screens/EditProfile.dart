import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spark/main.dart';
import '../image_picker.dart';
import 'colours.dart' as color;
import 'package:spark/models/User.dart' as spark_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool init = true;
  int? _selectedGender = 0;
  int? _selectedShow = 0;
  String imageUrl = "";

  spark_user.User user = spark_user.User('', '', '', '', 18, '', '');

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  void onValueChanged(String newValue) {
    setState(() {
      imageUrl = newValue;
    });
  }

  void saveChanges() {
    // add user to database
    final ref = FirebaseDatabase.instance.ref();
    user.gender = _getGenderTitle(_selectedGender!);
    user.seeking = _getShowTitle(_selectedShow!);
    if (user.username == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Your Name cant be Empty.'),
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
    } else {
      ref.child('users').child(user.ID).set(user.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (init && arguments != null) {
      user = arguments['user'];
      _selectedGender = _getGenderIndex(user.gender);
      _selectedShow = _getShowIndex(user.seeking);

      // Set the initial text for the fields using the controllers
      nameController.text = user.username;
      aboutMeController.text = user.description;
      init = false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            /*Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
            ),*/
            ImagePickerWidget(onValueChanged: onValueChanged, edit: "Edit"),

            // Name
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  user.username = value;
                });
              },
              controller: nameController,
            ),
            const SizedBox(height: 20),
            // About Me
            TextField(
              decoration: const InputDecoration(labelText: 'About Me'),
              onChanged: (value) {
                setState(() {
                  user.description = value;
                });
              },
              controller: aboutMeController,
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            // age
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Age: ${user.age}'),
            ),
            Slider(
              value: user.age.toDouble(),
              min: 18,
              max: 100,
              divisions: 100,
              label: user.age.toString(),
              onChanged: (double value) {
                setState(() {
                  user.age = value.toInt();
                });
              },
            ),
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
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: saveChanges,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(250, 50),
                textStyle: const TextStyle(fontSize: 10),
                side: const BorderSide(
                    width: 1.0,
                    color: color.colours
                        .primaryColorLight), // Increase the width as desired
                foregroundColor: color.colours.primaryColorLight,
              ),
              child: const Text(
                "Salvar  Alterações",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton(
                onPressed: () async {
                  firebase_auth.User? user = FirebaseAuth.instance.currentUser;
                  await user?.delete();
                  final ref = FirebaseDatabase.instance
                      .ref()
                      .child("users")
                      .child(user!.uid)
                      .remove()
                      .then((value) => Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                  textStyle: const TextStyle(fontSize: 10),
                  side: const BorderSide(
                      width: 1.0,
                      color: color
                          .colours.errorColor), // Increase the width as desired
                  foregroundColor: color.colours.primaryColorLight,
                ),
                child: const Text("Deletar Perfil"),
              ),
            ),
          ],
        ),
      ),
    );
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

  int _getGenderIndex(String title) {
    switch (title) {
      case 'Male':
        return 1;
      case 'Female':
        return 2;
      case 'Other':
        return 3;
      default:
        return 0; // Return 0 or any other default value for invalid title
    }
  }

  int _getShowIndex(String title) {
    switch (title) {
      case 'Males':
        return 1;
      case 'Females':
        return 2;
      case 'Everyone':
        return 3;
      default:
        return 0; // Return 0 or any other default value for invalid title
    }
  }
}
