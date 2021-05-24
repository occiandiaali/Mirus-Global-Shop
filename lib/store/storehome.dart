import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mirus_global/orders/my_orders.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:mirus_global/store/product_page.dart';

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
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Row(
                                    children: [
                                      Text('₦ ${cCy.format(model.price)}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                        ),
                                    ],

                                  ),
                                )
                                  : Container(
                                padding: EdgeInsets.all(5.0),
                               // margin: EdgeInsets.all(0.0),
                              ),

                              (model.discount != null
                                  && model.discount > 0) ?
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                     Text(
                                      '₦ ${cCy.format(
                                          model.price -
                                              (model.price * (model.discount / 100))
                                      )}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
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
                                      '₦ ${cCy.format(model.price)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (model.discount >= 15) ?
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  '* * * * *',
                                  style: TextStyle(
                                      fontSize: 21.0,
                                      color: Colors.yellow),
                                ),
                              )
                                  : Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  '* * *',
                                  style: TextStyle(
                                      fontSize: 21.0,
                                      color: Colors.yellow),
                                ),
                              ),
                              SizedBox(height: 5.0,),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'category: ${model.category}',
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
addItem(String shortInfoAsId, BuildContext context) {
  List tempCartList = EshopApp.sharedPreferences
      .getStringList(EshopApp.userOrderList);
  tempCartList.add(shortInfoAsId);

  EshopApp.firestore.collection(EshopApp.collectionUser)
      .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
  .set({
    EshopApp.userOrderList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: 'Item added to cart!');

    EshopApp.sharedPreferences.setStringList(EshopApp.userOrderList, tempCartList);

  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart

