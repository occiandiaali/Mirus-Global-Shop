import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';

import 'package:mirus_global/models/item.dart';

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

  @override
  Widget build(BuildContext context) {

   // Size screenSize = MediaQuery.of(context).size;
   //  cost = widget.itemModel.price * qtyOfItem;
    // itemQty = qtyOfItem;
    // itemQty = widget.itemModel.itemQty;




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
                          SizedBox(height: 2.0,),

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
                          SizedBox(height: 2.0,),
                          Text(
                            'Category: ${widget.itemModel.category}',
                            style: TextStyle(
                                fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          // Text(
                          //   widget.itemModel.qty.toString(),
                          //   style: boldTextStyle,
                          // ),
                                Row(
                                    children: [
                                      Text(
                                        "=N= ${widget.itemModel.price * qtyOfItem}",
                                     // "=N= $cost",
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
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          print('Product Page item qty: $qtyOfItem');
                            checkItemInCart(
                                widget.itemModel.shortInfo,
                                context);
                            },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            gradient: LinearGradient(
                              colors: [Colors.pink, Colors.blueGrey],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0,
                          height: 45.0,
                          child: Center(
                            child: Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 23.0,
                                  color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
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

const numPickerStyle = TextStyle(color: Colors.deepPurple);
const boldTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold, fontSize: 18);
const largeTextStyle = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 20.0);
