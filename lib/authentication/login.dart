import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Login Screen',
        style: TextStyle(fontSize: 35.0),
      ),
    );
  }
}