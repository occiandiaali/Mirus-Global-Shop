import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/customStepper.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/counters/total_amt.dart';

import 'package:mirus_global/models/item.dart';
import 'package:provider/provider.dart';

import './storehome.dart';
import './cart.dart';
import 'package:numberpicker/numberpicker.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int qtyOfItem = 1;
  //int cost = 0;
  //int itemQty;
  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0.0;

    // Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    final cCy = NumberFormat("#,##0.00");
    // Size screenSize = MediaQuery.of(context).size;
    //  cost = widget.itemModel.price * qtyOfItem;
    // itemQty = qtyOfItem;
    // itemQty = widget.itemModel.itemQty;

    totalAmount = widget.itemModel.price.toDouble();

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          widget.itemModel.thumbnailUrl,
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: TextStyle(fontSize: 25.0),
                          ),
                          Divider(
                            color: Colors.purple,
                            thickness: 0.9,
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            widget.itemModel.shortInfo,
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            color: Colors.purple,
                            thickness: 0.9,
                          ),
                          SizedBox(
                            height: 2.0,
                          ),

                          Text(
                            widget.itemModel.longDescription,
                            style: TextStyle(
                              fontSize: 19.0,
                            ),
                          ),
                          Divider(
                            color: Colors.purple,
                            thickness: 0.7,
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            'Category: ${widget.itemModel.category}',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          (widget.itemModel.discount != null &&
                                  widget.itemModel.discount > 0)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "=N= ${cCy.format((widget.itemModel.price - (widget.itemModel.price * (widget.itemModel.discount / 100))) * qtyOfItem)}",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    // SizedBox(width: 8.0,),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "=N= ${cCy.format(widget.itemModel.price * qtyOfItem)}",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    // SizedBox(width: 8.0,),
                                  ],
                                ),
                          // Row(
                          //   children: [
                          //     qtyPicker(),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // CustomStepper(
                      //   lowerLimit: 1,
                      //   upperLimit: 10,
                      //   stepValue: 1,
                      //   iconSize: 31,
                      //   value: qtyOfItem,
                      // ),
                      NumberPicker(
                          minValue: 1,
                          maxValue: 10,
                          axis: Axis.horizontal,
                          itemWidth: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(
                                color: Colors.deepPurple,
                              width: 3
                            ),
                          ),
                          value: qtyOfItem,
                          onChanged: (value) =>
                              setState(() => qtyOfItem = value)),
                      SizedBox(width: 35.0),
                      OutlinedButton(
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        onPressed: () {
                          addItem(widget.itemModel.shortInfo, context);
                          Route route = MaterialPageRoute(
                              builder: (c) => Address(
                                  totalAmount:
                                      (widget.itemModel.price).toDouble()));
                          Navigator.push(context, route);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(150.0, 50.0),
                          shape: StadiumBorder(),
                          side: BorderSide(width: 6, color: Colors.deepPurple),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: OutlinedButton(
                      //     child: Text(
                      //       'Place Order',
                      //       style: TextStyle(
                      //         fontSize: 21.0,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.deepPurple,
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       addItem(widget.itemModel.shortInfo, context);
                      //       Route route = MaterialPageRoute(builder: (c) =>
                      //           Address(totalAmount: (widget.itemModel.price).toDouble()));
                      //       Navigator.push(context, route);
                      //     },
                      //     style: OutlinedButton.styleFrom(
                      //       minimumSize: Size(150.0, 50.0),
                      //       shape: StadiumBorder(),
                      //       side: BorderSide(
                      //           width: 6,
                      //           color: Colors.deepPurple
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget qtyPicker() {
  //   return Row(
  //     children: [
  //       Text('Quantity: '),
  //       NumberPicker(
  //           minValue: 1,
  //           maxValue: 50,
  //           axis: Axis.horizontal,
  //           itemWidth: 40,
  //           textStyle: numPickerStyle,
  //           value: qtyOfItem,
  //           onChanged: (value) => setState(() => qtyOfItem = value)),
  //     ],
  //   );
  // }

} // class

addItem(String shortInfoAsId, BuildContext context) {
  List tempCartList =
      EshopApp.sharedPreferences.getStringList(EshopApp.userOrderList);
  tempCartList.add(shortInfoAsId);
  EshopApp.firestore
      .collection(EshopApp.collectionUser)
      .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
      .set({
    EshopApp.userOrderList: tempCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: 'Order placement commenced...');

    EshopApp.sharedPreferences
        .setStringList(EshopApp.userOrderList, tempCartList);

    // Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart

const numPickerStyle = TextStyle(color: Colors.deepPurple);
const boldTextStyle = TextStyle(
    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 18);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0);
