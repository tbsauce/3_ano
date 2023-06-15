import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spark/models/User.dart' as spark_user;
import 'package:logger/logger.dart';



class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<String> onValueChanged;
  final String edit;
  const ImagePickerWidget({required this.onValueChanged, required this.edit});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String childValue = '';

  File? _image;
  late String _imageUrl;
  firebase_auth.User? user = FirebaseAuth.instance.currentUser;

  
  final databaseRef = FirebaseDatabase.instance.ref();

  spark_user.User userToUpdate = spark_user.User('', '', '', '', 18, '', '');



  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await (saveFilePermanently(image.path));

      setState(() {
        _image = imagePermanent;
      });
      final imageUrl = await uploadImageToFirebase(_image!);
      widget.onValueChanged(imageUrl);
      _imageUrl = imageUrl;
      if(widget.edit == "Edit") getCurrentuser(user!.uid,imageUrl, databaseRef.child('users'));
      

      setState(() {
        _imageUrl = imageUrl;
       
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

 void getCurrentuser(String uid, String imageUrl, DatabaseReference db) async {
    DatabaseReference refUser =
        FirebaseDatabase.instance.ref().child("users/$uid");
    final snapshot = await refUser.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      userToUpdate = spark_user.User.fromMap(userData);
      userToUpdate.photoURL = imageUrl;
      db.child(userToUpdate.ID).set(userToUpdate.toMap());
      Logger().i(userToUpdate);
    } else {
      Logger().e("No user found");
    }
  }

  String getPhotoURL() {
    return _imageUrl;
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      final fileName = basename(image.path);
      final destination = 'images/$fileName';

      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      final uploadTask = ref.putFile(image);

      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
           

      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _image != null
              ? Image.file(
                  _image!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://thumbs.dreamstime.com/b/image-edit-tool-outline-icon-image-edit-tool-outline-icon-linear-style-sign-mobile-concept-web-design-photo-gallery-135346318.jpg',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
          const SizedBox(height: 20,),
          customButton(
            title: 'Pick from Gallery',
            icon: Icons.image_outlined,
            onClick: () => getImage(ImageSource.gallery),
          ),
          customButton(
            title: 'Take a picture',
            icon: Icons.camera_alt,
            onClick: () => getImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}

Widget customButton(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return SizedBox(
  width: 200,
  child: ElevatedButton(
    onPressed: onClick,
    child: Row(
      children: [
        Icon(icon), 
        const SizedBox(width: 20),
        Text(title),
      ],
    ),
  ),
);

}
