import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';



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
                        'Bank Transfer Details',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                    Text(
                        'Mirus Global Shipping ltd',
                    style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    Text(
                        'UBA account no. 0031236789',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                    Text(
                      'You will receive notification '
                          'on this app as soon as your payment is confirmed',
                      style: TextStyle(color: Colors.yellow, fontSize: 15.0),
                    ),
                    Text(
                      'Customer Care',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    Text(
                      '+23481122334455',
                      style: TextStyle(color: Colors.white, fontSize: 21.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              TextButton(
                child: Text('I Agree'),
                style: TextButton.styleFrom(
                  elevation: 10.0,
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                  ),
                ),
                onPressed: () => addOrderDetails(),
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
    Fluttertoast.showToast(msg: 'Payment must be confirmed BEFORE delivery.');
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