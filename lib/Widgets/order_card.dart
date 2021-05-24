import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/admin/admin_order_details.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/counters/item_quantity.dart';

import 'package:mirus_global/orders/order_details.dart';
import 'package:mirus_global/models/item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../store/storehome.dart';

int counter = 0;
int qtyItem = 0;

class OrderCard extends StatelessWidget {
   final int itemCount;
   final int qty;
  final List<DocumentSnapshot> data;
  final String orderID;
  final bool isEnabled;
  final String orderBy;
  final String addressID;

  OrderCard(
      {Key key,
      this.itemCount,
      this.qty,
      this.data,
      this.orderID,
      this.isEnabled,
      this.orderBy,
      this.addressID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
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
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 270.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());

            return sourceOrderInfo(
                model,
                context,
                oID: orderID,
               // qty: model.qty,
                isEButtonEnabled: isEnabled);
            // ********************************8
          },
        ),
      ),
    );
  }

} // class

Widget sourceOrderInfo(
    ItemModel model,
    BuildContext context,
    {Color background,
      String oID,
      //int total,
     // int qty,
     // int itemCount,
      bool isEButtonEnabled = true}) {

  width = MediaQuery.of(context).size.width;
  final cCy = NumberFormat("#,##0.00");
  return Container(
          color: Colors.grey[100],
          height: 190.0,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Image.network(
                  model.thumbnailUrl,
                  width: 150.0,
                ),
                SizedBox(
                  width: 6.0,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 37.0),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  model.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    (model.discount != null
                                        && model.discount > 0) ?
                                    Text(
                                      'Unit: ₦ ${cCy.format(
                                          model.price -
                                              (model.price * (model.discount / 100))
                                      )}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.green,
                                      ),
                                    )
                                        : Text(
                                      'Unit: ₦ ${cCy.format(model.price)}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Roboto',
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.0),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            'Awaiting confirmation'
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 9.0),
                                isEButtonEnabled ?
                                Row(
                                  children: [
                                    Text('Order Details ',),
                                    GestureDetector(
                                      onTap: () {
                                        Route route;
                                            route = MaterialPageRoute(
                                                builder: (c) =>
                                                    OrderDetails(
                                                        orderID: oID,));
                                            Navigator.push(context, route);
                                      },
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 29.0,
                                        color: Colors.deepPurple,
                                      ),
                                    ),

                                  ],
                                )
                                    : Text('Shop with us again!!!'),
                              ],
                            ),
                          ],
                        ),
                        Flexible(
                          child: Container(),
                        ),
                        Divider(
                          height: 4.0,
                          color: Colors.purpleAccent,
                          thickness: 0.5,
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        );
} // source order info

// ***************

// void _doubleCheckTotal(BuildContext ctx) {
//   showModalBottomSheet(
//       elevation: 10,
//       backgroundColor: Colors.amber,
//       context: ctx,
//       builder: (ctx) => Container(
//         padding: EdgeInsets.all(8.0),
//         width: 300,
//         height: 200,
//         color: Colors.white54,
//         alignment: Alignment.center,
//         child: Text(
//           'PLEASE, double-check the TOTAL amount to be paid. '
//               'If the TOTAL appears to be incorrect, return '
//               'to the previous screen and tap DETAILS again... '
//               'Otherwise, confirm all the details and proceed.',
//           style: TextStyle(color: Colors.deepPurple, fontSize: 23.0),),
//       ));
// }
