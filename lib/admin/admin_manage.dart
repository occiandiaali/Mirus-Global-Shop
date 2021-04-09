import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/store/cart.dart';
import 'package:mirus_global/store/edit_product_page.dart';
import 'package:mirus_global/store/product_page.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mirus_global/config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../models/item.dart';

double width;

class AdminManage extends StatefulWidget {
  @override
  _AdminManageState createState() => _AdminManageState();
}

class _AdminManageState extends State<AdminManage> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.blueGrey],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            'Management',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
             // fontFamily: 'Dancing Script',
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.settings_applications_outlined,
                    color: Colors.white,),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),

              ],
            ),
          ],
        ),
       // drawer: MyDrawer(),
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
                  itemBuilder: (context, index) {
                    ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());
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
}


Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  int timesOrdered = 12;
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (c) => EditProductPage(itemModel: model));
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
            Image.network(
              model.thumbnailUrl,
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // changed this
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
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
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.green,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white),),
                              Text(
                                'OFF',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  'Original price: =N= ',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                                Text(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  'New price: ',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),),
                                Text(
                                  '=N= ',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),),
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
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: removeCartFunction == null ?
                  //   IconButton(
                  //     onPressed: () {
                  //       checkItemInCart(model.shortInfo, context);
                  //     },
                  //     icon: Icon(
                  //         Icons.add_shopping_cart,
                  //         color: Colors.pinkAccent),
                  //   )
                  //       : IconButton(
                  //     onPressed: () => null,
                  //     icon: Icon(Icons.remove_shopping_cart),
                  //   ),
                  // ),
                  Text('Ordered $timesOrdered time(s)'),
                  Divider(
                    height: 10.0,
                    color: Colors.pinkAccent,
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



Widget card({Color primaryColor = Colors.pinkAccent, String imgPath}) {
  return Container();
}

// addItemToCart(String productid, BuildContext context) {
//   List tempCartList = EshopApp.sharedPreferences
//       .getStringList(EshopApp.userCartList);
//   tempCartList.add(productid);
//
//   EshopApp.firestore.collection(EshopApp.collectionUser)
//       .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
//       .update({
//     EshopApp.userCartList: tempCartList,
//   }).then((v) {
//     EshopApp.sharedPreferences
//         .setStringList(EshopApp.userCartList, tempCartList);
//     Fluttertoast.showToast(msg: 'Item added to cart!');
//
//     //  Provider.of<CartItemCounter>(context, listen: false).displayResult();
//   });
// }
//
//
//
// void checkItemInCart(String productID, BuildContext context) {
//   EshopApp.sharedPreferences
//       .getStringList(EshopApp.userCartList)
//       .contains(productID) ?
//   Fluttertoast.showToast(msg: 'Item already in cart') :
//   addItemToCart(productID, context);
// }