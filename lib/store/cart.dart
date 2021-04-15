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
          elevation: 10.0,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBar(),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
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

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
       // color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_shopping_cart_rounded,
                color: Colors.purple,
              size: 50.0,),
              Text(
                  'Your cart is empty!',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId) {
    List tempCartList = EshopApp.sharedPreferences
        .getStringList(EshopApp.userCartList);
    tempCartList.remove(shortInfoAsId);
    var userDocRef = EshopApp.firestore.collection(EshopApp.collectionUser)
        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID));
    userDocRef.set({
      EshopApp.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: 'Item removed from cart!');
      EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
      totalAmount = 0;
    }).catchError((e) => print("Error updating document: $e"));
  }

} // class