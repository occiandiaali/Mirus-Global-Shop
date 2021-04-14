import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/orders/place_order.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
//import 'package:mirus_global/Widgets/wideButton.dart';
//import 'package:mirus_global/models/address.dart';
//import 'package:mirus_global/counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({Key key, this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

    );
  }

  noAddressCard() {
    return Card(

    );
  }
}

class AddressCard extends StatefulWidget {

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {

    return InkWell(

    );
  }
}





class KeyText extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}