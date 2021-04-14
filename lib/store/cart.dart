import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';
//import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';

import 'package:mirus_global/counters/total_amt.dart';
import 'package:mirus_global/models/item.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
//import 'package:mirus_global/counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if(EshopApp.sharedPreferences.getStringList(
              EshopApp.userCartList
            ).length == 1) {
              Fluttertoast.showToast(msg: 'Your Cart is empty');
            } else {
              Route route = MaterialPageRoute(
                builder: (_) => Address(totalAmount: totalAmount)
              );
              Navigator.push(context, route);
            }
          },
      label: Text('Check Out'),
      backgroundColor: Colors.deepPurpleAccent,
      icon: Icon(Icons.navigate_next),),
      appBar: MyAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0 ?
                    Container() : Text(
                      "Total: =N=${amountProvider.totalAmount.toString()}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EshopApp.firestore.collection("items")
                .where(
                "shortInfo",
                whereIn: EshopApp.sharedPreferences
                    .getStringList(EshopApp.userCartList)).snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData ?
                  SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),),
                  )
                  : snapshot.data.docs.length == 0 ?
                  beginBuildingCart() : SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      ItemModel model = ItemModel.
                      fromJson(snapshot.data.docs[index].data());

                      if(index == 0) {
                        totalAmount = 0;
                        totalAmount = model.price + totalAmount;
                      } else {
                        totalAmount = model.price + totalAmount;
                      }

                      if(snapshot.data.docs.length - 1 == index) {
                        WidgetsBinding
                            .instance
                            .addPostFrameCallback((t) {
                              Provider.of<TotalAmount>(context, listen: false)
                                  .display(totalAmount);
                        });
                      }
                      return sourceInfo(
                          model,
                          context,
                          removeCartFunction: () => removeItemFromUserCart(model.shortInfo));
                    },
                  childCount: snapshot.hasData ?
                      snapshot.data.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),

    );
  }

  beginBuildingCart() {}

  removeItemFromUserCart(String shortInfoAsId) {}

} // class