import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/item_special.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/Widgets/order_card.dart';
import 'package:mirus_global/models/address.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:sms/sms.dart';
import 'package:telephony/telephony.dart';



String getOrderId = "";
double shippingCost = 0.00;

final cCy = NumberFormat("#,##0.00");

class OrderDetails extends StatelessWidget {

  final String orderID;


  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    getOrderId = orderID;


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
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
          ),
          centerTitle: true,
          title: Text(
            'Order Details',
            style: TextStyle(
                color: Colors.white
            ),),
          actions: [
            GestureDetector(
              onTap: () => forceClearDetails(context, getOrderId),
              child: Container(
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 20.0,),
          ],
        ),
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
                            alignment: Alignment.center,
                            child: Text(
                              'Total: ₦ ${cCy.format(
                                  dataMap[EshopApp.totalAmount])}',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                '( delivery fee NOT included )',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(4.0),
                        //   child: Align(
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       'Quantity ( ${dataMap[EshopApp.itemQuantity]} ) - '
                        //           'Size ( ${dataMap[EshopApp.itemSize]} )',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 15.0,
                        //           color: Colors.deepPurple
                        //       ),
                        //     ),
                        //   ),
                        // ),
                          Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'To: AJAYI IRETIOGO ESTHER,',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'UBA account no. 2100613436',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          //child: Text("Order ID: $getOrderId"),
                          child: SelectableText(
                            "ID: $getOrderId",
                            showCursor: true,
                            cursorColor: Colors.deepPurple,
                            cursorWidth: 5,
                            cursorRadius: Radius.circular(5),
                            toolbarOptions: ToolbarOptions(copy: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Date: ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                                .format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap['orderTime']))
                            )}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey
                            ),
                          ),
                        ),
                        Divider(height: 8.0,),
                        FutureBuilder<QuerySnapshot>(
                         future: EshopApp.firestore
                              .collection("items")
                              .where(
                              "shortInfo",
                              whereIn: dataMap[EshopApp.itemID])
                              .get(),

                          builder: (c, dataSnapshot) {
                            return dataSnapshot.hasData ?
                                OrderCard(
                                  itemCount: dataSnapshot.data.docs.length,
                                  data: dataSnapshot.data.docs,
                                  isEnabled: false,
                                )
                                : Center(child: circularProgress(),);
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
                                  orderId: orderID,
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

  forceClearDetails(BuildContext context, String mOrderId) {
    EshopApp.firestore
        .collection(EshopApp.collectionUser)
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .collection(EshopApp.collectionOrders)
        .doc(mOrderId).delete().then((value)  {
      getOrderId = "";

      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }

} // order details class



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
} // status banner class


class ShippingDetails extends StatelessWidget {

  final AddressModel model;
  final String orderId;
 // final Telephony telephony = Telephony.instance;

  ShippingDetails({Key key, this.model, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // shippingCost = model.state == 'Lagos' ||
    // model.state == 'lagos' ? 3500 : 12000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "DELIVERY DETAILS",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.all(4.0),
        //   child: Text(
        //     '( shipping: ₦ ${cCy.format(shippingCost)} )',
        //     style: TextStyle(
        //       color: Colors.red,
        //       fontSize: 21,
        //       fontFamily: 'Roboto',
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        Container(
          child: FutureBuilder<DocumentSnapshot>(
            future: EshopApp.firestore
                .collection(EshopApp.collectionUser)
                .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
                .collection(EshopApp.collectionOrders)
                .doc(orderId).get(),
            builder: (c, shot) {
              Map dataMap;
              if(shot.hasData) {
                dataMap = shot.data.data();
              }
              return shot.hasData ?
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Quantity: ${dataMap[EshopApp.itemQuantity]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.deepPurple
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                  'Size: ${dataMap[EshopApp.itemSize]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.deepPurple
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                  'Colour: ${dataMap[EshopApp.itemColour]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.deepPurple
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Center(child: circularProgress(),);
            },
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
                  Text(
                      model.name,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Phone',),
                  Text(
                      model.phoneNumber,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Street',),
                  Text(
                      model.street,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'City',),
                  Text(
                      model.city,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'State',),
                  Text(
                      model.state,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  KeyText(msg: 'Country',),
                  Text(
                      model.country,
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 8.0,),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () => confirmOrderReceived(context, getOrderId),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
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
                width: MediaQuery.of(context).size.width - 170.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    'Confirm Correct',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(height: 8.0,),
      ],
    );
  }

  // void smsWork() {
  //   For sms plugin in pubsec yaml
  //   var sender = SmsSender();
  //   String recipient = "09088018515";
  //   var msg = SmsMessage(recipient, 'I just confirmed my order payment');
  //   msg.onStateChanged.listen((event) {
  //     if(event == SmsMessageState.Sent) {
  //       Fluttertoast.showToast(msg: 'SMS confirmation sent to merchant',
  //               toastLength: Toast.LENGTH_LONG);
  //     } else if(event == SmsMessageState.Delivered) {
  //       Fluttertoast.showToast(msg: 'Merchant has received SMS confirmation',
  //           toastLength: Toast.LENGTH_LONG);
  //     }
  //   });
  //   sender.sendSms(msg);
  // }

  confirmOrderReceived(BuildContext context, String mOrderId) {
    EshopApp.firestore
        .collection(EshopApp.collectionUser)
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
        .collection(EshopApp.collectionOrders)
        .doc(mOrderId).delete().then((value) {
      getOrderId = "";

      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.pushReplacement(context, route);
    });
  }


} // class
