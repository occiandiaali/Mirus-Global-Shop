import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/orders/order_details.dart';
import 'package:mirus_global/models/item.dart';
import 'package:provider/provider.dart';

import '../store/storehome.dart';


int counter = 0;
class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({
  Key key,
  this.itemCount,
  this.data,
  this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Route route;
        if(counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }
        Navigator.push(context, route);
      },
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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
            itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (c, index) {
              ItemModel model = ItemModel.fromJson(data[index].data());
              return sourceOrderInfo(model, context);
        },),
      ),
    );
  }
}



Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  width =  MediaQuery.of(context).size.width;
  final qtyItem = Provider.of<ItemQuantity>(context);
  return  Container(
    color: Colors.grey[100],
    height: 170.0,
    width: width,
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl,
          width: 180.0,
        ),
        SizedBox(width: 10.0,),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Qty: ${qtyItem.numberOfItems}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),),

                            // Text(
                            //   (model.price).toString(),
                            //   style: TextStyle(
                            //     fontSize: 15.0,
                            //     color: Colors.grey,
                            //   ),),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '=N= ${model.price}',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
              Flexible(
                child: Container(),
              ),
              Divider(
                height: 10.0,
                color: Colors.purpleAccent,
                thickness: 0.5,),
            ],
          ),
        ),
      ],
    ),
  );


} // source order info