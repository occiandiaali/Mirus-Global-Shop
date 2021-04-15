import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mirus_global/authentication/auth_screen.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/counters/address_changer.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/total_amt.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'counters/cartitemcounter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EshopApp.auth = FirebaseAuth.instance;
  EshopApp.sharedPreferences = await SharedPreferences.getInstance();
  EshopApp.firestore = FirebaseFirestore.instance;

  runApp(MG());
}

class MG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
        child: MaterialApp(
          title: 'MG Shop',
          debugShowCheckedModeBanner: true,
          theme: ThemeData(
            primaryColor: Colors.purple,
            fontFamily: 'Ubuntu',
          ),
          home: SplashScreen(),
        ),
    );
  }
} // main class

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 5), () async {
      if (EshopApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.blueGrey,
              Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.4, 0.6, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/mglogo.png"),
              SizedBox(height: 20.0,),
              Text(
                'Africa\'s largest On-line supplier',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Dancing Script',
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

