import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mirus_global/widgets/customTextField.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _confirmPassEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 8.0,),
            InkWell(
              onTap: () => print("Selected..."),
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
                    controller: _nameEditingController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObscured: false,
                  ),
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
                  CustomTextField(
                    controller: _confirmPassEditingController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObscured: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => print('Reg click...'),
              child: Text('Register'),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
