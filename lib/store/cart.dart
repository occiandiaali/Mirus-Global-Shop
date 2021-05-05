import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/config/config.dart';
//import 'package:mirus_global/address/address.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:mirus_global/counters/total_amt.dart';
import 'package:mirus_global/models/item.dart';
import 'package:mirus_global/counters/cartitemcounter.dart';
import './cart_card.dart';


import 'package:mirus_global/store/storehome.dart';



class CartPage extends StatefulWidget {

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0.0;
   // numberOfItems = 1;
  // numberOfItems = Provider.of<ItemQuantity>(context, listen: false).numberOfItems;
    Provider.of<TotalAmount>(context, listen: false).display(0);

  }

  @override
  Widget build(BuildContext context) {
   final quantityOfItem = Provider.of<ItemQuantity>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 10.0,
            onPressed: () {
              if(EshopApp.sharedPreferences.getStringList(
                EshopApp.userCartList
              ).length == 1) {
                Fluttertoast.showToast(msg: 'Your Cart is empty');
              } else {
                Route route = MaterialPageRoute(
                  builder: (c) => Address(totalAmount: totalAmount)
                );
                Navigator.push(context, route);
              }
            },
        label: Text('Place Order'),
        backgroundColor: Colors.deepPurpleAccent,
        icon: Icon(Icons.navigate_next),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: MyAppBar(),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0 ?
                    Container()
                        : Text(
                      "TOTAL =N= ${amountProvider.totalAmount}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),

                  ),

                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EshopApp.firestore.collection("items")
                .where(
                "shortInfo",
                whereIn: EshopApp.sharedPreferences
                    .getStringList(EshopApp.userCartList)).snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData ?
                  SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),),
                  )
                  : snapshot.data.docs.length == 0 ?
                  showEmptyCart()
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      ItemModel model = ItemModel.
                      fromJson(snapshot.data.docs[index].data());
                      int len = snapshot.data.docs.length;
                      int q = quantityOfItem.numberOfItems;

                      if(index == 0 && len >= 1) {
                        totalAmount = 0;
                       // totalAmount = model.price.toDouble();
                        // if(quantityOfItem.numberOfItems > 1) {
                        //   totalAmount -= model.price;
                        //   totalAmount = (model.price * quantityOfItem.numberOfItems).toDouble();
                        // }
                        totalAmount += q > 1 ?
                            model.price * q : model.price;
                      } else {
                        totalAmount += model.price;
                      }


                      if(snapshot.data.docs.length - 1 == index) {
                        WidgetsBinding
                            .instance
                            .addPostFrameCallback((t) {
                              Provider.of<TotalAmount>(context, listen: false)
                                  .display(totalAmount);
                        });
                      }
                      // return cartInfo(
                      //     model,
                      //     context,
                      //     removeCartFunction: () => removeItemFromUserCart(model.shortInfo));
                      return CartCard(
                          model,
                          context,
                      );

                    },
                  childCount: snapshot.hasData ?
                      snapshot.data.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),

    );
  }

  showEmptyCart() {
    return SliverToBoxAdapter(
      child: Card(
       // color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_shopping_cart_rounded,
                color: Colors.purple,
              size: 50.0,),
              Text(
                  'Your cart is empty!',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Select items from the store...',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // removeItemFromUserCart(String shortInfoAsId) {
  //   List tempCartList = EshopApp.sharedPreferences
  //       .getStringList(EshopApp.userCartList);
  //   tempCartList.remove(shortInfoAsId);
  //   var userDocRef = EshopApp.firestore.collection(EshopApp.collectionUser)
  //       .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID));
  //   userDocRef.set({
  //     EshopApp.userCartList: tempCartList,
  //   }).then((v) {
  //     Fluttertoast.showToast(msg: 'Item removed from cart!');
  //     EshopApp.sharedPreferences.setStringList(EshopApp.userCartList, tempCartList);
  //     Provider.of<CartItemCounter>(context, listen: false).displayResult(EshopApp.userCartList.length);
  //     totalAmount = 0;
  //   }).catchError((e) => print("Error updating document: $e"));
  // }

  // ****************************************
  // Widget cartInfo( ItemModel model, BuildContext context,
  //     {Color background, removeCartFunction}) {
  //  // String cartWidgetID = model.shortInfo;
  //  // int unitPrice = model.price;
  //   return InkWell(
  //     // onTap: () {
  //     //   Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model,));
  //     //   Navigator.push(context, route);
  //     // },
  //     splashColor: Colors.grey,
  //     child: Padding(
  //       padding: EdgeInsets.all(6.0),
  //       child: Container(
  //         height: 230.0,
  //         width: width,
  //         child: Row(
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(15.0),
  //               child: Image.network(
  //                 model.thumbnailUrl,
  //                 width: 120.0,
  //                 height: 140.0,
  //               ),
  //             ),
  //             SizedBox(width: 14.0,),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 45.0),
  //                   Container(
  //                     child: Row(
  //                       mainAxisSize: MainAxisSize.max,
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             model.title,
  //                             style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 18.0,
  //                             ),),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.0,),
  //                   Container(
  //                     child: Row(
  //                       mainAxisSize: MainAxisSize.max,
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             "Category: ${model.category}",
  //                             style: TextStyle(
  //                               color: Colors.black54,
  //                               fontSize: 12.0,
  //                             ),),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.0,),
  //                   Row(
  //                     children: [
  //                       SizedBox(width: 7.0,),
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(top: 0.0),
  //                             child: Text(
  //                               '${model.qty} pieces in stock',
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(top: 0.0),
  //                             child: Row(
  //                               children: [
  //                                 Text(
  //                                   // cartWidgetID == model.shortInfo ?
  //                                   // '=N= ${model.price * qtyOfItem}'
  //                                   // : '=N= ${model.price}',
  //                                   '=N= ${model.price * numberOfItems}',
  //                                   style: TextStyle(
  //                                     fontSize: 19.0,
  //                                     color: Colors.green,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(top: 2.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Text('Quantity: '),
  //                                SizedBox(width: 1.0,),
  //                                // qtyPicker(),
  //                                 NumberPicker(
  //                                     minValue: 1,
  //                                     maxValue: 50,
  //                                     axis: Axis.horizontal,
  //                                     itemWidth: 40,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //                                       border: Border.all(color: Colors.deepPurple),
  //                                     ),
  //                                     // textStyle: numPickerStyle,
  //                                     value: numberOfItems,
  //                                     onChanged: (value) => setState(() {
  //                                       // print("shortInfo: ${model.shortInfo}");
  //                                       //  print("widgetID: $cartWidgetID");
  //                                        print("numberOfItems: $numberOfItems");
  //                                        numberOfItems = value;
  //                                     })
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //
  //                     ],
  //                   ),
  //                   Flexible(
  //                     child: Container(),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerRight,
  //                     child: IconButton(
  //                       onPressed: () {
  //                         removeCartFunction();
  //                         Route route = MaterialPageRoute(
  //                             builder: (c) => StoreHome()
  //                         );
  //                         Navigator.push(context, route);
  //                       },
  //                       icon: Icon(Icons.delete_forever,
  //                           color: Colors.purpleAccent),
  //                     ),
  //                   ),
  //                   Divider(
  //                     height: 2.0,
  //                     color: Colors.purpleAccent,
  //                     thickness: 0.5,),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //     ),
  //   );
  //
  // } // cart info
 // *******************************************

// Widget qtyPicker() {
//      return NumberPicker(
//           minValue: 1,
//           maxValue: 50,
//           axis: Axis.horizontal,
//           itemWidth: 36,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(15.0)),
//             border: Border.all(color: Colors.deepPurple),
//           ),
//          // textStyle: numPickerStyle,
//           value: qtyOfItems,
//           onChanged: (value) => setState(() {
//               qtyOfItems = value;
//           })
//       );
//
// } // qty picker
// =======================================
// int priceAdjuster() {
//     numberOfItems = int.parse(_itemQtyController.text);
//     Fluttertoast.showToast(
//         msg: 'Qty: ${int.parse(_itemQtyController.text)}',
//       toastLength: Toast.LENGTH_LONG,
//     );
//     _itemQtyController.clear();
//     return numberOfItems;
// }
// ===================================

// =======================================

} // class





