import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/config/config.dart';
import 'package:flutter/services.dart';
import 'package:mirus_global/orders/order_details.dart';
import 'package:mirus_global/store/storehome.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/order_card.dart';


class MyOrders extends StatefulWidget {

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

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
            'Order Overview',
            style: TextStyle(
              color: Colors.white
            ),),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EshopApp.firestore
              .collection(EshopApp.collectionUser)
              .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
              .collection(EshopApp.collectionOrders).snapshots(),

          builder: (c, snapshot) {
          //  return !snapshot.hasData ?
            return (!snapshot.hasData || snapshot.data.size < 1) ?
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/storefront.png',
                    height: 450.0,
                    width: 350.0,),
                ),
                Text(
                  'No orders here yet...',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
                : ListView.builder(
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
                    OrderCard(
                      itemCount: snap.data.docs.length,
                      data: snap.data.docs,
                      orderID: snapshot.data.docs[index].id,
                      isEnabled: true,
                    )
                        : Center(child: circularProgress(),);

                  },
                );
              },
            );
               // : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  } // build widget


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