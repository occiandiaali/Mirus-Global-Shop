import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/dialog_box/error_dialog.dart';
import 'package:mirus_global/dialog_box/loading_dialog.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/Widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 32.0,),
            InkWell(
              onTap: () => _imageSelectAndPick(),
            child: CircleAvatar(
              radius: _screenWidth * 0.15,
              backgroundColor: Colors.white,
              backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
              child: _imageFile == null ?
              Icon(
                Icons.add_a_photo,
                size: _screenWidth * 0.15,
              color: Colors.grey,) : null,
            ),
            ),
            SizedBox(height: 8.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    data: Icons.person_add_outlined,
                    hintText: 'what should we call you?',
                    isObscured: false,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    data: Icons.mail_outlined,
                    hintText: 'you@emailhost.whatever',
                    isObscured: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    data: Icons.security_outlined,
                    hintText: 'Type a secure password (min 6 xters)',
                    isObscured: true,
                  ),
                  CustomTextField(
                    controller: _confirmPassController,
                    data: Icons.security_outlined,
                    hintText: 'Please re-enter the password',
                    isObscured: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => uploadAndSaveImg(),
              child: Text('Register'),
            ),
            SizedBox(
              height: 30.0,
            ),

          ],
        ),
      ),
    );
  }

  // this is called to select/load user profile image from device
Future<void> _imageSelectAndPick() async {
  final picker = ImagePicker();
  PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
  _imageFile = File(pickedFile.path);
}

Future<void> uploadAndSaveImg() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) => ErrorAlertDialog(
            message: 'Select an image file to proceed...',
          )
      );
    } else {
      _passwordController.text == _confirmPassController.text
          ? _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty &&
          _nameController.text.isNotEmpty
          ? uploadToStorage()
          : _displayDialog('Provide ALL credentials')
          : _displayDialog('Password confirm does not match');
    }
}

_displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(message: msg,);
      }
    );
}

uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) => LoadingAlertDialog(message: 'Registering you, Please wait.....',)
    );

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask storageUploadTask = storageReference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
}

FirebaseAuth _auth = FirebaseAuth.instance;
void _registerUser() async {
  User firebaseUser;
  
  await _auth.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim()
  ).then((auth) {
    firebaseUser = auth.user;
  }).catchError((error) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(message: error.toString());
      }
    );
  });

  if (firebaseUser != null) {
    saveUserInfoToFireStore(firebaseUser).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }
}

Future saveUserInfoToFireStore(User fUser) async {
  FirebaseFirestore.instance.collection("users").add({
    "uid": fUser.uid,
    "name": _nameController.text.trim(),
    "email": fUser.email,
    "url": userImageUrl,
    EshopApp.userCartList: ["garbageValue"],
  }).then((s) {
    print("Collection created...");
  }).catchError((error) {
    print("Error adding document: $error");
  });

  await EshopApp.sharedPreferences.setString("uid", fUser.uid);
  await EshopApp.sharedPreferences.setString(EshopApp.userEmail, fUser.email);
  await EshopApp.sharedPreferences.setString(EshopApp.userName, _nameController.text);
  await EshopApp.sharedPreferences.setString(EshopApp.userAvatarUrl, userImageUrl);
  await EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, ["garbageValue"]);
} // save user info to fire store


} // class
