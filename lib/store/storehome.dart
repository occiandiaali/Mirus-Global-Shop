import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/counters/item_quantity.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.deepPurple,
                      ),

                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 7.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            // return Text(
                            //   // counter.count != null ?
                            //   // counter.count.toString() : circularProgress(),
                            //     (counter.count != null) ?
                            //     (EshopApp.sharedPreferences
                            //     .getStringList(EshopApp.userCartList)
                            //     .length - 1).toString() : "0",
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 12.0,
                            //     fontWeight: FontWeight.w500
                            //   ),
                            // );
                            return counter.count != null ?
                                Text(
                                (EshopApp.sharedPreferences
                                        .getStringList(EshopApp.userCartList)
                                        .length - 1).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500
                                      ),
                                )
                                : Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                    return removeCartFunction == null ?
                      sourceInfo(model, context) : CartPage();
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


Widget sourceInfo(ItemModel model, BuildContext context,{Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model,));
      Navigator.push(context, route);
    },
    splashColor: Colors.grey,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                model.thumbnailUrl,
                width: 120.0,
                height: 140.0,
              ),
            ),
            SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 45.0),
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
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            "Category: ${model.category}",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //         color: Colors.deepPurple,
                      //     width: 2.0),
                      //     shape: BoxShape.rectangle,
                      //    // color: Colors.deepPurple,
                      //   ),
                      //   alignment: Alignment.topLeft,
                      //   width: 40.0,
                      //   height: 43.0,
                      //   child: Center(
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //               '50%',
                      //               style: TextStyle(
                      //                   fontSize: 15.0,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.deepPurple),),
                      //
                      //           Text(
                      //               'OFF',
                      //               style: TextStyle(
                      //                   fontSize: 10.0,
                      //               color: Colors.deepPurple),
                      //             ),
                      //
                      //         ],
                      //       ),
                      //   ),
                      // ),
                      SizedBox(width: 7.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Text(
                                '${model.qty} pieces in stock',
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                          '=N=${(model.price + model.price)}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      ),
                                    SizedBox(width: 15.0,),
                                    Text(
                                        'Old',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                    color: Colors.grey),),

                                  ],

                                ),
                              ),

                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [

                                  Text(
                                      '=N= ${model.price}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  SizedBox(width: 15.0),
                                  Text(
                                      'New',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                    color: Colors.green),),
                                  // Text(
                                  //     '=N= ',
                                  //     style: TextStyle(
                                  //       fontSize: 14.0,
                                  //       color: Colors.deepPurple,
                                  //     ),
                                  //   ),
                                  //   Text(
                                  //     (model.price).toString(),
                                  //     style: TextStyle(
                                  //       fontSize: 14.0,
                                  //       color: Colors.purple,
                                  //     ),
                                  //   ),

                                ],
                              ),
                            ),
                          ],
                        ),

                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                  //  child: removeCartFunction == null ?
                    child: IconButton(
                      onPressed: () {
                        print("StoreHome ID: ${model.shortInfo}");
                        print("StoreHome =N=: ${model.price}");
                        checkItemInCart(
                        model.shortInfo,
                            context);
                      },
                      icon: Icon(
                          Icons.add_shopping_cart,
                      color: Colors.purpleAccent),
                    )
                    // : IconButton(
                    //       onPressed: () {
                    //         removeCartFunction();
                    //         Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    //         Navigator.push(context, route);
                    //       },
                    //       icon: Icon(Icons.delete_forever,
                    //           color: Colors.purpleAccent),
                    //     ),
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

addItemToCart(String shortInfoAsId, BuildContext context) {
  List tempCartList = EshopApp.sharedPreferences
      .getStringList(EshopApp.userCartList);
  tempCartList.add(shortInfoAsId);

  EshopApp.firestore.collection(EshopApp.collectionUser)
      .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
  .set({
    EshopApp.userCartList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: 'Item added to cart!');

    EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart



void checkItemInCart(String productID, BuildContext context) {
  print('Check item in cart');
  EshopApp.sharedPreferences
      .getStringList(EshopApp.userCartList)
      .contains(productID) ?
      Fluttertoast.showToast(msg: 'Item already in cart') :
      addItemToCart(productID, context);
}