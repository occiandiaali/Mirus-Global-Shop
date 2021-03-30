import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MG());
}

class MG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirus Global Store',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: Colors.red,
        fontFamily: 'Ubuntu',
      ),
      home: SplashScreen(),
    );
  }
} // main class

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text(
          'Welcome to Mirus Global Store',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

