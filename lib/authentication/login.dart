import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/admin/admin_signin.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/dialog_box/error_dialog.dart';
import 'package:mirus_global/dialog_box/loading_dialog.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/widgets/customTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                  'images/welcome.png',
              height: 240.0,
              width: 240.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sign in to your account',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailEditingController,
                    data: Icons.email,
                    hintText: 'Email',
                    isObscured: false,
                  ),
                  CustomTextField(
                    controller: _passwordEditingController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObscured: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _emailEditingController.text.isNotEmpty &&
                    _passwordEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                  context: context,
                  builder: (c) => ErrorAlertDialog(message: 'email AND password required',)
                );
              },
              child: Text('Sign In'),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.green,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminSignIn())),
              icon: Icon(
                  Icons.admin_panel_settings_outlined,
              color: Colors.white,),
              label: Text(
                  'Admin signin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
 void loginUser() async {
    showDialog(
      context: context,
      builder: (c) => LoadingAlertDialog(message: 'Checking your credentials...')
    );
    User firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailEditingController.text.trim(),
        password: _passwordEditingController.text.trim(),
    ).then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser)
          .then((s) {
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
      });
    }
 }

 Future readData(User fUser) async {
   FirebaseFirestore.instance.collection("users")
       .doc(fUser.uid)
       .get()
       .then((dataSnapshot) async {
     await EshopApp.sharedPreferences.setString("uid", dataSnapshot.data()[EshopApp.userUID]);
     await EshopApp.sharedPreferences.setString(EshopApp.userEmail, dataSnapshot.data()[EshopApp.userEmail]);
     await EshopApp.sharedPreferences.setString(EshopApp.userName, dataSnapshot.data()[EshopApp.userName]);
     await EshopApp.sharedPreferences.setString(EshopApp.userAvatarUrl, dataSnapshot.data()[EshopApp.userAvatarUrl]);

     List<String> cartList = dataSnapshot.data()[EshopApp.userCartList].cast<String>();
     await EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, cartList);
   });
 }

Future dummyData(User fUser) async {
  FirebaseFirestore.instance.collection("users")
      .doc(fUser.uid)
      .get()
      .then((value) async {
          EshopApp.sharedPreferences.getString("uid");
          EshopApp.sharedPreferences.getString(EshopApp.userEmail);
          EshopApp.sharedPreferences.getString(EshopApp.userName);
          EshopApp.sharedPreferences.getString(EshopApp.userAvatarUrl);

         // List<String> cartList = value.data()[EshopApp.userCartList].cast<String>();
          EshopApp.sharedPreferences.getStringList(EshopApp.userCartList).cast<String>();

  }).catchError((error) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: error.toString());
        }
    );
  });
}

} // class
