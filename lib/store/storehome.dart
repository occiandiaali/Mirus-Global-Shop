import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/orders/my_orders.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:mirus_global/store/cart.dart';
import 'package:mirus_global/store/product_page.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';

import 'package:mirus_global/config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../models/item.dart';


double width;

class StoreHome extends StatefulWidget {

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            //
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
          title: Text(
            'MG Shop',
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Dancing Script',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              iconSize: 29,
              icon: Icon(
                Icons.article_outlined,
                color: Colors.white),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => MyOrders());
                  Navigator.push(context, route);
                },
            ),
            // Stack(
            //   children: [
            //     IconButton(
            //       icon: Icon(
            //         Icons.shopping_cart_outlined,
            //         color: Colors.white,),
            //       onPressed: () {
            //         Route route = MaterialPageRoute(builder: (c) => CartPage());
            //         Navigator.push(context, route);
            //       },
            //     ),
            //     Positioned(
            //       child: Stack(
            //         children: [
            //           Icon(
            //             Icons.brightness_1,
            //             size: 20.0,
            //             color: Colors.deepPurple,
            //           ),
            //
            //           Positioned(
            //             top: 3.0,
            //             bottom: 4.0,
            //             left: 7.0,
            //             child: Consumer<CartItemCounter>(
            //               builder: (context, counter, _) {
            //                 // return Text(
            //                 //   // counter.count != null ?
            //                 //   // counter.count.toString() : circularProgress(),
            //                 //     (counter.count != null) ?
            //                 //     (EshopApp.sharedPreferences
            //                 //     .getStringList(EshopApp.userCartList)
            //                 //     .length - 1).toString() : "0",
            //                 //   style: TextStyle(
            //                 //     color: Colors.white,
            //                 //     fontSize: 12.0,
            //                 //     fontWeight: FontWeight.w500
            //                 //   ),
            //                 // );
            //                 return counter.count != null ?
            //                 Text(
            //                     (EshopApp.sharedPreferences
            //                             .getStringList(EshopApp.userCartList).length - 1).toString(),
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 12.0,
            //                             fontWeight: FontWeight.w500
            //                           ),
            //                     )
            //                     : Text(
            //                   '0',
            //                   style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 12.0,
            //                       fontWeight: FontWeight.w500
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SearchBoxDelegate(),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("items")
                      .limit(15).orderBy("publishedDate", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData ?
                    SliverToBoxAdapter(child: Center(child: circularProgress(),))
                        : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index, {Color background, removeCartFunction}) {
                        ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());
                        // return removeCartFunction == null ?
                        // sourceInfo(model, context) : CartPage();
                        return sourceInfo(model, context);
                      },
                      itemCount: snapshot.data.docs.length,
                    );
                  },
                ),
              ],
            ),
      ),
    );

  }

} // class


Widget sourceInfo(
    ItemModel model,
    BuildContext context,
    {Color background,
      removeCartFunction}) {
  final cCy = NumberFormat("#,##0.00");
  return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model,));
        Navigator.push(context, route);
      },
      splashColor: Colors.purpleAccent,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 190.0,
          width: width,
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      model.thumbnailUrl,
                      width: 120.0,
                      height: 140.0,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.0),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              model.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.0,),
                    Row(
                      children: [
                        SizedBox(width: 7.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Text(
                                  model.shortInfo,
                                ),
                              ),
                              (model.discount != null
                                  && model.discount > 0) ?
                              Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: Row(
                                    children: [
                                      Text('=N= ${cCy.format(model.price)}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        ),
                                    ],

                                  ),
                                )
                                  : Container(
                                margin: EdgeInsets.all(0.0),
                              ),

                              (model.discount != null
                                  && model.discount > 0) ?
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                     Text(
                                      '=N= ${cCy.format(
                                          model.price -
                                              (model.price * (model.discount / 100))
                                      )}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text(
                                      '${model.discount}% OFF',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.deepPurple,
                                      ),
                                    )
                                  ],
                                ),
                              )
                                  : Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                      '=N= ${cCy.format(model.price)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            //  SizedBox(height: 5.0,),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'type: ${model.category}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),

                            ], // kids
                          ),

                      ],
                    ),
                    Flexible(
                      child: Container(),
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    // //  child: removeCartFunction == null ?
                    //   child: IconButton(
                    //     onPressed: () {
                    //       // print("StoreHome ID: ${model.shortInfo}");
                    //       // print("StoreHome =N=: ${model.price}");
                    //       checkItemInCart(
                    //       model.shortInfo,
                    //           context);
                    //     },
                    //     icon: Icon(
                    //         Icons.add_shopping_cart,
                    //     color: Colors.purpleAccent),
                    //   )
                    //   // : IconButton(
                    //   //       onPressed: () {
                    //   //         removeCartFunction();
                    //   //         Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    //   //         Navigator.push(context, route);
                    //   //       },
                    //   //       icon: Icon(Icons.delete_forever,
                    //   //           color: Colors.purpleAccent),
                    //   //     ),
                    // ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        child: Text('Order'),
                        onPressed: () => addItem(model.shortInfo, context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(20.0, 30.0),
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                    width: 4,
                                    color: Colors.deepPurple
                                  ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2.0,
                      color: Colors.purpleAccent,
                      thickness: 0.5,),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
} // source info

// *******************************

// ***********************************



// Widget card({Color primaryColor = Colors.purpleAccent, String imgPath}) {
//   return Container(
//     height: 150.0,
//     width: width * 0.34,
//     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     decoration: BoxDecoration(
//       color: Colors.indigoAccent,
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(20.0),
//         bottomRight: Radius.circular(20.0),
//       ),
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(20.0)),
//       child: Image.network(
//         imgPath,
//         height: 150.0,
//         width: width * 0.34,
//         fit: BoxFit.fill,
//       ),
//     ),
//   );
// }

addItem(String shortInfoAsId, BuildContext context) {
  List tempCartList = EshopApp.sharedPreferences
      .getStringList(EshopApp.userOrderList);
  tempCartList.add(shortInfoAsId);

  // if(tempCartList.length <= 2) {
  //   EshopApp.firestore.collection(EshopApp.collectionUser)
  //       .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
  //       .set({
  //     EshopApp.userCartList: tempCartList,
  //   }).then((v) {
  //     Fluttertoast.showToast(msg: 'Item added to cart!');
  //
  //     EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, tempCartList);
  //
  //     Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  //   }).catchError((e) => print("Error updating document: $e"));
  // } else {
  //   Fluttertoast.showToast(
  //       msg: 'Pls, add/process only one item in your cart at a time...',
  //   gravity: ToastGravity.CENTER,
  //   toastLength: Toast.LENGTH_LONG);
  // }
  EshopApp.firestore.collection(EshopApp.collectionUser)
      .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
  .set({
    EshopApp.userOrderList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: 'Item added to cart!');

    EshopApp.sharedPreferences.setStringList(EshopApp.userOrderList, tempCartList);

  //  Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart



// void checkItemInCart(String productID, BuildContext context) {
//  // print('Check item in cart');
//   EshopApp.sharedPreferences
//       .getStringList(EshopApp.userCartList)
//       .contains(productID) ?
//       Fluttertoast.showToast(msg: 'Item already in cart') :
//       addItemToCart(productID, context);
// }