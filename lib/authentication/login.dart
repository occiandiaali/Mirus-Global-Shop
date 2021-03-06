import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/admin/admin_signin.dart';
import 'package:mirus_global/admin/uploaditems.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/dialog_box/error_dialog.dart';
import 'package:mirus_global/dialog_box/loading_dialog.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/Widgets/customTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //double _screenWidth = MediaQuery.of(context).size.width;
    //double _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                  'images/storefront.png',
              height: 300.0,
              width: 300.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sign in to the shop',
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailController,
                    data: Icons.mail_outlined,
                    hintText: 'Email',
                    isObscured: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    data: Icons.security_outlined,
                    hintText: 'Password',
                    isObscured: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
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
                if(_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  (
                      _emailController.text == 'fdiali76@gmail.com' ||
                          _emailController.text == 'treasureevent48@gmail.com'
                  ) ?
                      _loginAdmin() : _loginUser();
                } else {
                  showDialog(
                      context: context,
                      builder: (c) =>
                          ErrorAlertDialog(
                            message: 'Email AND Password are required',));
                }
              },
              child: Text('Sign in'),
            ),
            SizedBox(height: 45.0,),

          ],
        ),
      ),
    );
  }

  Future readInfoData(User fUser) async {
    FirebaseFirestore.instance.collection("users")
        .doc(fUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            await EshopApp.sharedPreferences.setBool(
                "isAdmin",
                documentSnapshot.data()[EshopApp.isAdmin]);
           await EshopApp.sharedPreferences.setString(
               EshopApp.userUID, documentSnapshot.data()[EshopApp.userUID]);
            await EshopApp.sharedPreferences.setString(
                EshopApp.userName, documentSnapshot.data()[EshopApp.userName]);
           await EshopApp.sharedPreferences.setString(
                EshopApp.userAvatarUrl, documentSnapshot.data()[EshopApp.userAvatarUrl]);
           await EshopApp.sharedPreferences.setString(
                EshopApp.userEmail, documentSnapshot.data()[EshopApp.userEmail]);

           List<String> cartList = documentSnapshot.data()[EshopApp.userCartList].cast<String>();
           await EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, cartList);
          }
    });
  } // read info data

  _loginAdmin() async {
    showDialog(
        context: context,
        builder: (c) => LoadingAlertDialog(message: 'Just checking...')
    );
    var adminUser = EshopApp.auth.currentUser;
    await EshopApp.auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    ).then((authUser) {
      adminUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            // return ErrorAlertDialog(message: error.toString());
            return ErrorAlertDialog(
                message: 'Could not verify you.');
          }
      );
    });
    if(adminUser != null) {
     // String adminName = "Admin";
      // firestore issue: https://stackoverflow.com/questions/52024666/firestore-delete-document-and-security-rules
      readInfoData(adminUser)
          .then((_) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => UploadPage(adminUser.email));
        Navigator.pushReplacement(context, route);
      }).catchError((e) {});
    }
  } // login admin


  _loginUser() async {
    showDialog(
        context: context,
        builder: (c) => LoadingAlertDialog(message: 'Verifying you...')
    );
   // User firebaseUser;
    var firebaseUser = EshopApp.auth.currentUser;
    await EshopApp.auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
           // return ErrorAlertDialog(message: error.toString());
            return ErrorAlertDialog(
                message: 'Something is wrong. Check your internet connection, '
                    ' and confirm the correct email AND password...');
          }
      );
    });

    if (firebaseUser != null) {
      readInfoData(firebaseUser)
        .then((s) {
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
        });
    }
  } // login user

} // class


