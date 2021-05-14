import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/admin/admin_order_card.dart';
import 'package:mirus_global/admin/admin_shift_orders.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/models/address.dart';

import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';


String getOrderId = "";
String getOrderBy = "";
String getAddressId = "";

class AdminOrderDetails extends StatelessWidget {

  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({
    Key key,
    this.orderID,
    this.orderBy,
    this.addressID,
}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    getOrderId = orderID;
    getOrderBy = orderBy;
    getAddressId = addressID;

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
            'Customer Orders',
            style: TextStyle(
                color: Colors.white
            ),),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.arrow_drop_down_circle_rounded,
          //       color: Colors.white,),
          //      onPressed: () => SystemNavigator.pop(),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EshopApp.firestore
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
                    AdminStatusBanner(status: dataMap[EshopApp.isSuccess],),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Total: =N= ${dataMap[EshopApp.totalAmount]}',
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
                          '(Remember to add delivery fees)'
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      //child: Text("Order ID: $getOrderId"),
                      child: SelectableText(
                        "Order ID: $getOrderId",
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
                        AdminOrderCard(
                          itemCount: dataSnapshot.data.docs.length,
                          data: dataSnapshot.data.docs,
                          isEnabled: false,
                          isAdmin: true,
                        )
                            : Center(child: circularProgress(),);
                      },
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<DocumentSnapshot>(
                      future: EshopApp.firestore
                          .collection(EshopApp.collectionUser)
                          .doc(orderBy)
                          .collection(EshopApp.subCollectionAddress)
                          .doc(addressID)
                          .get(),

                      builder: (c, snap) {
                        return snap.hasData ?
                        AdminShippingDetails(
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

// void _showAdm(BuildContext ctx) {
//   showModalBottomSheet(
//       elevation: 10,
//       backgroundColor: Colors.amber,
//       context: ctx,
//       builder: (ctx) => Container(
//         padding: EdgeInsets.all(8.0),
//         width: 300,
//         height: 100,
//         color: Colors.white54,
//         alignment: Alignment.center,
//         child: Text(
//           'Ensure you select image and fill fields!',
//           style: TextStyle(color: Colors.deepPurple, fontSize: 23.0),),
//       ));
// }

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({
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
          // GestureDetector(
          //   onTap: () => print("icon tapped"),
          //   child: Container(
          //     child: Icon(
          //       Icons.arrow_drop_down_circle_outlined,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          //SizedBox(width: 20.0,),
          Text(
            'Order Received: $msg',
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

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;
  final Telephony telephony = Telephony.instance;

  AdminShippingDetails({Key key, this.model}) : super(key: key);

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
            "DELIVERY DETAILS",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5.0,),
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
              onTap: () => confirmOrderShipped(context, getOrderId),
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
                    "Clear if order has been shipped",
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

  confirmOrderShipped(BuildContext context, String mOrderId) {
    EshopApp.firestore
        .collection(EshopApp.collectionOrders)
        .doc(mOrderId)
        .delete();
    telephony.sendSms(
        to: model.phoneNumber,
        message: '''
        Your order has been processed.
        Order ID: $getOrderId
        Due to international shipping 
        and/or merchant delays delivery takes a MINIMUM of 30 days.
        ''');
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
    Navigator.pushReplacement(context, route);

  }
}
