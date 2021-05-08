import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/orders/my_orders.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:mirus_global/orders/order_details.dart';
import 'package:mirus_global/config/config.dart';

import 'package:mirus_global/counters/cartitemcounter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telephony/telephony.dart';

const _mailUrl = 'mailto:treasureevent48@gmail.com?subject=MG Shop order placement';

class OrderPayment extends StatefulWidget {

  final String addressId;
  final double totalAmount;

  OrderPayment({
    Key key,
    this.addressId,
    this.totalAmount}) : super(key: key);

  @override
  _OrderPaymentState createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  final Telephony telephony = Telephony.instance;

  // void _sendSMS(String msg, List<String> recipients) async {
  //   await sendSMS(message: msg, recipients: recipients)
  //       .catchError((onError) {
  //         print('Error: $onError');
  //     Fluttertoast.showToast(
  //         msg: 'Could not send SMS',
  //     toastLength: Toast.LENGTH_LONG);
  //   });
  // }

  void _launchURL() async {
    await canLaunch(_mailUrl) ?
    await launch(_mailUrl) : Fluttertoast.showToast(
        msg: 'Could not launch Email service...',
        toastLength: Toast.LENGTH_LONG);
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
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Enquiries? Call the number below :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Customer Care',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    Text(
                      '+234-908-801-8515',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 23,
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
                    SizedBox(height: 6.0,),
                    Text(
                      'Kindly pay to below account',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 7.0,),
                    Text(
                        'Bank Transfer Details',
                    style: TextStyle(
                      fontSize: 21.0,
                      color: Colors.white,
                    ),),
                    Text(
                        'Mirus Global Shipping Ltd.',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0),
                    ),
                    Text(
                        'UBA account no. 0031236789',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    SizedBox(height: 6.0,),
                    Text(
                      'Payment must be confirmed BEFORE delivery.',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                    Text(
                      'NO RETURN policy on already shipped orders.',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                    Text(
                      'Accept terms, or cancel, by clicking below',
                      style: TextStyle(color: Colors.yellow, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7.0,),
              OutlinedButton(
                onPressed: () {
                  // telephony.sendSms(
                  //     to: "09088018515",
                  //     message: "Customer accepted order T & C");
                  addOrderDetails();
                },
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
    await EshopApp.firestore
        .collection(EshopApp.collectionOrders)
        .doc(EshopApp.sharedPreferences
            .getString(EshopApp.userUID) + data['orderTime'])
        .set(data);
  }

  emptyCartNow() {
    EshopApp.sharedPreferences
        .setStringList(EshopApp.userCartList, ["garbageValue"]);
    List tempList = EshopApp.sharedPreferences.getStringList(EshopApp.userCartList);

    FirebaseFirestore.instance.collection("users")
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .update({
      EshopApp.userCartList: tempList,
    }).then((value) {
      EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false)
          .displayResult(EshopApp.userCartList.length);
    });
    Fluttertoast.showToast(
        msg: 'Full payment must be confirmed BEFORE delivery.',
    gravity: ToastGravity.CENTER,
    toastLength: Toast.LENGTH_LONG);

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  addOrderDetails() {
    writeOrderDetailsUser({
      EshopApp.addressID: widget.addressId,
      EshopApp.totalAmount: widget.totalAmount,
      "orderBy": EshopApp.sharedPreferences.getString(EshopApp.userUID),
      EshopApp.productID: EshopApp.sharedPreferences.getStringList(EshopApp.userCartList),
      EshopApp.paymentDetails: "Bank Transfer",
      EshopApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EshopApp.isSuccess: true,
    });

    writeOrderDetailsAdmin({
      EshopApp.addressID: widget.addressId,
      EshopApp.totalAmount: widget.totalAmount,
      "orderBy": EshopApp.sharedPreferences.getString(EshopApp.userUID),
      EshopApp.productID: EshopApp.sharedPreferences.getStringList(EshopApp.userCartList),
      EshopApp.paymentDetails: "Bank Transfer",
      EshopApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EshopApp.isSuccess: true,
    }).whenComplete(() => emptyCartNow());
  }


} // class