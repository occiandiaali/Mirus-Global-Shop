import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/admin/uploaditems.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
import 'package:mirus_global/dialog_box/error_dialog.dart';
//import 'package:mirus_global/admin/uploadItems.dart';
//import 'package:mirus_global/authentication/authenication.dart';
import 'package:mirus_global/widgets/customTextField.dart';
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
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
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
              height: 20.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/admin.png',
                height: 240.0,
                width: 240.0,),
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
                    data: Icons.badge,
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
              onPressed: () {
                _adminIDEditingController.text.isNotEmpty &&
                    _passwordEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                    context: context,
                    builder: (c) => ErrorAlertDialog(message: 'email AND password required',)
                );
              },
              child: Text('Log In'),
            ),
            SizedBox(
              height: 150.0,
            ),

          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("admins")
        .get().then((snapshot) {
          snapshot.docs.forEach((result) {
            if (result.data()["id"] != _adminIDEditingController.text.trim()) {
              Scaffold.of(context).showBottomSheet((context) => Text('Invalid ID'));
            } else if (result.data()["password"] != _passwordEditingController.text.trim()) {
              Scaffold.of(context).showBottomSheet((context) => Text('Invalid password'));
            } else {
              Scaffold.of(context).showBottomSheet((context) => Text('Welcome, ${result.data()['name']}!'));

              setState(() {
                _adminIDEditingController.text = "";
                _passwordEditingController.text = "";
              });

              Route route = MaterialPageRoute(builder: (c) => UploadPage());
              Navigator.pushReplacement(context, route);
            }
          });
    });
  }


} // class