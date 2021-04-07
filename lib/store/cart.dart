import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/config/config.dart';
//import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/widgets/loadingWidget.dart';
import 'package:mirus_global/models/item.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
//import 'package:mirus_global/counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User cart'),
      ),
      body: Center(
        child: Text('Your Cart is EMPTY'),
      ),
    );
  }
}