import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:mirus_global/admin/adminOrderCard.dart';
import 'package:mirus_global/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/loadingWidget.dart';
//import '../widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Orders'),
      ),
      body: Center(
        child: Text('Shift ORders'),
      ),
    );
  }
}