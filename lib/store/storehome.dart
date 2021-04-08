import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/store/cart.dart';
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

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
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
                        child: Text(
                            '0',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),),
                      ),
                      // Positioned(
                      //   top: 3.0,
                      //   bottom: 4.0,
                      //   left: 5.0,
                      //   child: Consumer<CartItemCounter>(
                      //     builder: (context, counter, _) {
                      //       return Text(
                      //         counter.count.toString(), // bug area
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w500,
                      //           fontSize: 12.0,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
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
                      mainAxisSize: MainAxisSize.max,
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



void checkItemInCart(String productID, BuildContext context)
{
}