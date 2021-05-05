import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/order_card.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {

  void _showMyOrdersDropdown(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.amber,
        context: ctx,
        builder: (ctx) => Container(
          width: 300,
          height: 150,
          color: Colors.white54,
          alignment: Alignment.center,
          child: Text(
            'My Orders settings will show here...',
            style: TextStyle(color: Colors.deepPurple, fontSize: 23.0),),
        ));
  }

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
            'My Orders',
            style: TextStyle(
              color: Colors.white
            ),),
          actions: [
            IconButton(
              icon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
              color: Colors.white,),
             // onPressed: () => SystemNavigator.pop(),
              onPressed: () => _showMyOrdersDropdown(context),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EshopApp.firestore
              .collection(EshopApp.collectionUser)
              .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
              .collection(EshopApp.collectionOrders).snapshots(),

          builder: (c, snapshot) {
            return snapshot.hasData ?
                ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("items")
                          .where(
                          "shortInfo",
                          whereIn: snapshot.data.docs[index].data()[EshopApp.productID])
                          .get(),

                      builder: (c, snap) {
                        return snap.hasData ?
                            OrderCard(
                              itemCount: snap.data.docs.length,
                              data: snap.data.docs,
                              orderID: snapshot.data.docs[index].id,
                            )
                            : Center(child: circularProgress(),);
                      },
                    );
                  },
                ) : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}