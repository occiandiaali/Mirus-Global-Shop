import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/admin/admin_order_card.dart';
import 'package:mirus_global/config/config.dart';

import '../Widgets/loadingWidget.dart';
import '../Widgets/order_card.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
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
            'Pending Order',
            style: TextStyle(
                color: Colors.white
            ),),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.arrow_drop_down_circle_outlined,
          //       color: Colors.white,),
          //     // onPressed: () => SystemNavigator.pop(),
          //     onPressed: () => print('Placed Orders dropdown functionality here...'),
          //   ),
          // ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .snapshots(),

          builder: (c, snapshot) {
           // return snapshot.hasData ?
            return snapshot.data.size < 1 ?
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/mg_launch.png',
                    height: 450.0,
                    width: 350.0,),
                ),
                Text(
                    'No orders placed yet...',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ) :
            ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where(
                      "shortInfo",
                      whereIn: snapshot.data.docs[index].data()[EshopApp.itemID])
                      .get(),

                  builder: (c, snap) {
                    return snap.hasData ?
                    AdminOrderCard(
                      itemCount: snap.data.docs.length,
                      data: snap.data.docs,
                      isEnabled: true,
                      isAdmin: true,
                      orderID: snapshot.data.docs[index].id,
                      orderBy: snapshot.data.docs[index].data()["orderBy"],
                      addressID: snapshot.data.docs[index].data()["addressID"],
                    )
                        : Center(
                      child: circularProgress(),

                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}