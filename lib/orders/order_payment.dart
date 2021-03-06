import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:mirus_global/counters/item_colour.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/item_size.dart';
import 'package:mirus_global/counters/item_special.dart';
import 'package:mirus_global/orders/my_orders.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:mirus_global/orders/order_details.dart';
import 'package:mirus_global/config/config.dart';

import 'package:mirus_global/counters/cartitemcounter.dart';
import 'package:url_launcher/url_launcher.dart';


const _mailUrl = 'mailto:mirusglobalimportation@gmail.com?subject=Concerning my order placement';
var sizeOfItem = " ";
var colourOfItem = " ";

class OrderPayment extends StatefulWidget {

  final String addressId;
  final double totalAmount;
  final int itemQty;
  final String itemSize;
  final Color itemColour;


  OrderPayment({
    Key key,
    this.addressId,
    this.totalAmount,
    this.itemQty,
    this.itemSize,
    this.itemColour,
  }) : super(key: key);

  @override
  _OrderPaymentState createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {

  void _launchURL() async {
    await canLaunch(_mailUrl) ?
    await launch(_mailUrl) : Fluttertoast.showToast(
        msg: 'Make sure that you can send emails from this device...',
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {

    sizeOfItem = Provider.of<ItemSize>(context).getSizeOfItem;
    colourOfItem = Provider.of<ItemColour>(context).colorOfItems;

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
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'READ CAREFULLY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                      ),
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      'Questions or Complaints?',
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                    SizedBox(height: 3.0,),
                    Text(
                      '09038717572 (WhatsApp ONLY)',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    SizedBox(height: 3.0,),
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 3.0,),
                    ElevatedButton(
                      child: Text('Send Email'),
                      onPressed: _launchURL,
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10
                        ),
                        textStyle: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      'Please pay to below account',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 7.0,),
                    Text(
                        'AJAYI IRETIOGO ESTHER',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0),
                    ),
                    Text(
                        'UBA account no. 2100613436',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      'Payment must be confirmed BEFORE delivery.',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      'DELIVERY: ???2, 000 (Lagos), ???3, 500 (Otherwise)',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      'NO RETURN policy on already shipped orders.',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                    SizedBox(height: 9.0,),
                    Text(
                      'Click I ACCEPT to place order',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      'Click CANCEL to go back',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7.0,),
              OutlinedButton(
                onPressed: () => addOrderDetails(),
                child: Text(
                  'I Accept',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future writeOrderDetailsUser(Map<String, dynamic> data) async {
    await EshopApp.firestore.collection(EshopApp.collectionUser)
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .collection(EshopApp.collectionOrders)
        .doc(
        EshopApp.sharedPreferences
            .getString(EshopApp.userUID) + data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsAdmin(Map<String, dynamic> data) async {
    await EshopApp.firestore.collection(EshopApp.collectionOrders)
        .doc(EshopApp.sharedPreferences
            .getString(EshopApp.userUID) + data['orderTime'])
        .set(data);
  }


  clearOrder() {
    EshopApp.sharedPreferences
        .setStringList(EshopApp.userOrderList, ["dummyValue"]);
    List tempItem = EshopApp.sharedPreferences.getStringList(EshopApp.userOrderList);

    FirebaseFirestore.instance.collection("users")
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .update({
      EshopApp.userOrderList: tempItem,
    }).then((value) {
      EshopApp.sharedPreferences.setStringList(EshopApp.userOrderList, tempItem);
    });
    Fluttertoast.showToast(
        msg: 'Thanks, check ORDERS tab for details...',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG);

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  addOrderDetails() {
    writeOrderDetailsUser({
      EshopApp.addressID: widget.addressId,
      EshopApp.totalAmount: widget.totalAmount,
      EshopApp.itemQuantity: widget.itemQty,
      EshopApp.itemSize: sizeOfItem,
      EshopApp.itemColour: colourOfItem,
      "orderBy": EshopApp.sharedPreferences.getString(EshopApp.userUID),
      EshopApp.itemID: EshopApp.sharedPreferences.getStringList(EshopApp.userOrderList),
      EshopApp.paymentDetails: "Bank Transfer",
      EshopApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EshopApp.isSuccess: true,
    });

    writeOrderDetailsAdmin({
      EshopApp.addressID: widget.addressId,
      EshopApp.totalAmount: widget.totalAmount,
      EshopApp.itemQuantity: widget.itemQty,
      EshopApp.itemSize: sizeOfItem,
      EshopApp.itemColour: colourOfItem,
      "orderBy": EshopApp.sharedPreferences.getString(EshopApp.userUID),
      EshopApp.itemID: EshopApp.sharedPreferences.getStringList(EshopApp.userOrderList),
      EshopApp.paymentDetails: "Bank Transfer",
      EshopApp.orderTime: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      EshopApp.isSuccess: true,
       }).whenComplete(() => clearOrder());

  } // add order details

} // class