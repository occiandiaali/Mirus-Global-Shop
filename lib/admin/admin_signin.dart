import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mirus_global/admin/uploaditems.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/dialog_box/error_dialog.dart';
//import 'package:mirus_global/admin/uploadItems.dart';
//import 'package:mirus_global/authentication/authenication.dart';
import 'package:mirus_global/Widgets/customTextField.dart';
//import 'package:mirus_global/dialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.blueGrey],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'MG Shop',
          style: TextStyle(
            fontSize: 35.0,
            color: Colors.white,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final _adminIDEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  @override
  void dispose() {
    _adminIDEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // double _screenWidth = MediaQuery.of(context).size.width;
   // double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black12, Colors.blueGrey],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 41.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/adminlogo.png',
                height: 150.0,
                width: 150.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin login',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDEditingController,
                    data: Icons.wc_rounded,
                    hintText: 'Admin ID',
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
            SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10
                ),
                textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _adminIDEditingController.text.isNotEmpty &&
                    _passwordEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                    context: context,
                    builder: (c) => ErrorAlertDialog(message: 'adminID AND password required',)
                );
              },
              child: Text('Log In'),
            ),
            SizedBox(
              height: 450.0,
            ),

          ],
        ),
      ),
    );
  } // build widget


  loginAdmin() {
    FirebaseFirestore.instance.collection("admins")
        .get().then((snapshot) {
          snapshot.docs.forEach((result) {
            if (result.data()["id"] != _adminIDEditingController.text.trim()) {
              Scaffold.of(context).showBottomSheet((context) => Text('Invalid ID'));
            } else if (result.data()["password"] != _passwordEditingController.text.trim()) {
              Scaffold.of(context).showBottomSheet((context) => Text('Invalid password'));
            } else {
             // Scaffold.of(context).showBottomSheet((context) => Text('Welcome, ${result.data()['name']}!'));
              String adminUser = result.data()['name'].toString(); // get string value admin name
                setState(() {
                  _adminIDEditingController.text = "";
                  _passwordEditingController.text = "";
                });
                Route route = MaterialPageRoute(
                    builder: (c) => UploadPage(adminUser));
                Navigator.pushReplacement(context, route);
                // Navigator.push(context, route);

            }
          });
    });
  } // login admin


} // class