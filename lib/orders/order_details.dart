import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/Widgets/order_card.dart';
import 'package:mirus_global/models/address.dart';

import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {

  final String orderID;

  OrderDetails({
    Key key,
  this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    getOrderId = orderID;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EshopApp.firestore
                .collection(EshopApp.collectionUser)
                .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
                .collection(EshopApp.collectionOrders)
                .doc(orderID).get(),

            builder: (c, snapshot) {
              Map dataMap;
              if(snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData ?
                  Container(
                    child: Column(
                      children: [
                        StatusBanner(status: dataMap[EshopApp.isSuccess],),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '=N=${dataMap[EshopApp.totalAmount]}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Order ID: $getOrderId"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Order date: ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                                .format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap['orderTime']))
                            )}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey
                            ),
                          ),
                        ),
                        Divider(height: 2.0,),
                        FutureBuilder<QuerySnapshot>(
                          future: EshopApp.firestore
                              .collection("items")
                              .where(
                              "shortInfo",
                              whereIn: dataMap[EshopApp.productID])
                              .get(),

                          builder: (c, dataSnapshot) {
                            return dataSnapshot.hasData ?
                                OrderCard(
                                  itemCount: dataSnapshot.data.docs.length,
                                  data: dataSnapshot.data.docs,
                                ) : Center(child: circularProgress(),);
                          },
                        ),
                        Divider(height: 2.0,),
                        FutureBuilder<DocumentSnapshot>(
                          future: EshopApp.firestore
                              .collection(EshopApp.collectionUser)
                              .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
                              .collection(EshopApp.subCollectionAddress)
                              .doc(dataMap[EshopApp.addressID])
                              .get(),

                          builder: (c, snap) {
                            return snap.hasData ?
                                ShippingDetails(
                                  model: AddressModel.fromJson(snap.data.data())
                                ) : Center(child: circularProgress(),);
                          },
                        ),
                      ],
                    ),
                  )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}



class StatusBanner extends StatelessWidget {

  final bool status;

  StatusBanner({
    Key key,
    this.status,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Success!" : msg = "Failed!";
    return Container(
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
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => print("icon tapped"),
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            'Order Placed: $msg',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ShippingDetails extends StatelessWidget {

  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Delivery details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 90.0,
            vertical: 5.0,
          ),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(msg: 'Name',),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Phone',),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Street',),
                  Text(model.street),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'City',),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'State',),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Country',),
                  Text(model.country),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () => confirmOrderReceived(context, getOrderId),
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "I confirm order is received",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmOrderReceived(BuildContext context, String mOrderId) {
    EshopApp.firestore
        .collection(EshopApp.collectionUser)
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .collection(EshopApp.collectionOrders)
        .doc(mOrderId).delete();

    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(
        msg: 'You just confirmed that you\'ve received your order');
  }



} // class
