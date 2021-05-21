import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/counters/item_colour.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/item_size.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
  double itemAmount;
  double priceWithDiscount;
  double price;
  String selectedItemSize = 'Small';
  ColorSwatch _tempMainColor;
  Color _tempShadeColor;
  ColorSwatch _mainColor = Colors.blue;
  Color _shadeColor = Colors.blue[800];

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SELECT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  } // open dialogue

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() {
          _tempShadeColor = color;
         // Provider.of<ItemColour>(context, listen: false).colourOfItem(_shadeColor);
        }),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        // onBack: () => print("Back button pressed"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    totalAmount = 0.0;

    // Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    final cCy = NumberFormat("#,##0.00");

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
                          Row(
                            children: [
                              DropdownButton(
                                hint: Text('Select size'),
                                value: selectedItemSize,
                                style: TextStyle(
                                    fontSize: 19.0, color: Colors.deepPurple),
                                items: [
                                  DropdownMenuItem(
                                      child: Text(
                                        'Small',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      value: 'Small'),
                                  DropdownMenuItem(
                                      child: Text(
                                        'Medium',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      value: 'Medium'),
                                  DropdownMenuItem(
                                      child: Text(
                                        'Large',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      value: 'Large'),
                                  DropdownMenuItem(
                                      child: Text(
                                        'Extra-large',
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                      value: 'Extra-large'),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedItemSize = value;
                                    // Provider.of<ItemSize>(
                                    //     context, listen: false)
                                    //     .sizeOfItem(selectedItemSize);
                                  });
                                },
                              ),
                              SizedBox(
                                width: 55.0,
                              ),
                              Text(
                                'Item colour',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.deepPurple),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              CircleColor(
                                color: _shadeColor,
                                circleSize: 25,
                                iconSelected: Icons.brightness_1_rounded,
                                elevation: 4.0,
                                onColorChoose: _openColorPicker,
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
                                "=N= ${cCy.format(calcTotalAmount())}",
                                /*
                                (widget.itemModel.price -
                                    (widget.itemModel.price * (widget.itemModel.discount / 100)) *
                                        qtyOfItem)
                                * */
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
                                  "=N= ${cCy.format(calcTotalAmount())}",
                                  //(widget.itemModel.price * qtyOfItem).toDouble()
                                  style: TextStyle(
                                    fontSize: 25.0,
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
                          // int quantityOfItem = Provider.of<ItemQuantity>
                          //   (context, listen: false).numberOfItems;
                          Route route = MaterialPageRoute(
                              builder: (c) => Address(
                                totalAmount: calcTotalAmount(),
                                itemQty: qtyOfItem,
                                itemSize: selectedItemSize,
                                itemColour: _shadeColor,
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
                          maxValue: 10,
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

    // Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  }).catchError((e) => print("Error updating document: $e"));
} // add item to cart

const numPickerStyle = TextStyle(color: Colors.deepPurple);
const boldTextStyle = TextStyle(
    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 18);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0);
