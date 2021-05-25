import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/counters/item_colour.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/item_size.dart';
import 'package:mirus_global/counters/item_special.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:intl/intl.dart';

import 'package:mirus_global/Widgets/customAppBar.dart';

import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';

import 'package:mirus_global/models/item.dart';
import 'package:provider/provider.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int qtyOfItem = 1;

  double totalAmount;
  double itemAmount;
  double priceWithDiscount;
  double price;
  String selectedItemSize;
  String selectedItemColour;
  String itemSize;

  List availableItemSizes = []; // to store admin input sizes
  List availableItemColours = []; // to store admin input colours

  @override
  void initState() {
    super.initState();

    totalAmount = 0.0;

  }

  @override
  Widget build(BuildContext context) {
    final cCy = NumberFormat("#,##0.00");

    totalAmount = widget.itemModel.price.toDouble();

    availableItemSizes = widget.itemModel.dimensions.split(",");
    availableItemColours = widget.itemModel.colour.split(",");

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
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0),
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
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15.0),
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
                              color: Colors.deepPurple
                            ),
                          ),
                          Divider(
                            color: Colors.purple,
                            thickness: 0.7,
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                             Row(
                            children: [
                                  Text(
                                    'Size:',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.deepPurple),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                              DropdownButton(
                                items: availableItemSizes.map((dynamic value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedItemSize = value;
                                   // debugPrint('Size: $selectedItemSize');
                                    Provider.of<ItemSize>(
                                      context,
                                      listen: false,
                                    ).sizeOfItem(selectedItemSize);
                                  });
                                },
                                value: selectedItemSize,
                              ),
                              SizedBox(
                                width: 11.0,
                              ),
                              Text(
                                  'Colour:',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(width: 9.0,),
                              DropdownButton(
                                items: availableItemColours.map((dynamic c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  );
                                }).toList(),
                                onChanged: (c) {
                                  setState(() {
                                    selectedItemColour = c;
                                   // debugPrint('Colour: $selectedItemColour');
                                    Provider.of<ItemColour>(
                                      context,
                                      listen: false,
                                    ).colourOfItem(selectedItemColour);
                                  });
                                },
                                value: selectedItemColour,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                            (widget.itemModel.discount != null &&
                              widget.itemModel.discount > 0) ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₦ ${cCy.format(calcTotalAmount())}",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 25.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              // SizedBox(width: 8.0,),
                            ],
                          )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₦ ${cCy.format(calcTotalAmount())}",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'Roboto',
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                // SizedBox(width: 8.0,),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
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
                          Route route = MaterialPageRoute(
                              builder: (c) => Address(
                                totalAmount: calcTotalAmount(),
                                itemQty: qtyOfItem,
                                itemSize: selectedItemSize,
                              ));
                          Navigator.push(context, route);
                          addItem(widget.itemModel.shortInfo, context);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(150.0, 50.0),
                          shape: StadiumBorder(),
                          side: BorderSide(width: 6, color: Colors.deepPurple),
                        ),
                      ),
                      SizedBox(width: 35.0),
                      NumberPicker(
                          minValue: 1,
                          maxValue: 50,
                          axis: Axis.horizontal,
                          itemWidth: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            border:
                                Border.all(color: Colors.deepPurple, width: 3),
                          ),
                          value: qtyOfItem,
                          onChanged: (value) =>
                              setState(() {
                                qtyOfItem = value;
                                widget.itemModel.qty = qtyOfItem;
                                Provider.of<ItemQuantity>(
                                    context,
                                    listen: false).qtyOfItem(widget.itemModel.qty);
                              })),
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

  double calcTotalAmount() {
    double total = 0.00;
    total = (widget.itemModel.discount != null &&
        widget.itemModel.discount > 0) ?
   (widget.itemModel.price -
        (widget.itemModel.price * (widget.itemModel.discount / 100))) * qtyOfItem
        : (widget.itemModel.price).toDouble() * qtyOfItem;
    return total;
  }

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

  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart

const numPickerStyle = TextStyle(color: Colors.deepPurple);
const boldTextStyle = TextStyle(
    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 18);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0);
