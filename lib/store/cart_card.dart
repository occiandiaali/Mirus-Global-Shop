import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/counters/total_amt.dart';
import 'package:mirus_global/models/item.dart';
import 'package:mirus_global/store/storehome.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {

  final ItemModel model;
 // int qtyOfitem;
  final BuildContext context;

  CartCard(
      this.model,
  this.context);

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int itemQty = 1;

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
     // totalAmount = 0;
    }).catchError((e) => print("Error updating document: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model,));
      //   Navigator.push(context, route);
      // },
      splashColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 230.0,
          width: width,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  widget.model.thumbnailUrl,
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
                              widget.model.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 5.0,),
                    // Container(
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           "Category: ${widget.model.category}",
                    //           style: TextStyle(
                    //             color: Colors.black54,
                    //             fontSize: 12.0,
                    //           ),),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                                '${widget.model.qty - itemQty} pieces in stock',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    '=N= ${widget.model.price * itemQty}',
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Shipping: =N= ${widget.model.price * (10 / 100)}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  Text('Quantity: '),
                                  // qtyPicker(),
                                  NumberPicker(
                                      minValue: 1,
                                      maxValue: 50,
                                      axis: Axis.horizontal,
                                      itemWidth: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        border: Border.all(color: Colors.deepPurple),
                                      ),
                                      // textStyle: numPickerStyle,
                                      value: itemQty,
                                      onChanged: (value) => setState(() {
                                        itemQty = value;
                                        widget.model.qty -= value;
                                       // print("widget.qtyOfItem: $itemQty");
                                        // Provider for qty of each ordered item
                                        Provider.of<ItemQuantity>(
                                            context,
                                            listen: false,
                                        ).qtyOfItem(itemQty);

                                        // Provider for items in stock
                                        Provider.of<ItemQuantity>(
                                          context,
                                          listen: false,
                                        ).qtyOfItemInStock(widget.model.qty);
                                      }),
                                  )
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
                      child: IconButton(
                        onPressed: () {
                         removeItemFromUserCart(widget.model.shortInfo);
                          Route route = MaterialPageRoute(
                              builder: (c) => StoreHome()
                          );
                          Navigator.push(context, route);
                        },
                        icon: Icon(Icons.delete_forever,
                            color: Colors.purpleAccent),
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
  }



} // class
