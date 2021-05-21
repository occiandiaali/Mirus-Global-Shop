import 'package:flutter/material.dart';
import 'package:mirus_global/counters/address_changer.dart';
import 'package:mirus_global/counters/item_quantity.dart';
import 'package:mirus_global/orders/order_payment.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirus_global/address/add_address.dart';
import 'package:mirus_global/config/config.dart';
import 'package:mirus_global/models/address.dart';
import 'package:mirus_global/orders/place_order.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/Widgets/loadingWidget.dart';
import 'package:mirus_global/Widgets/wideButton.dart';




class Address extends StatefulWidget {

  final double totalAmount;
  final int itemQty;
  final String itemSize;
  final Color itemColour;

  const Address({
    Key key,
    this.totalAmount,
    this.itemQty,
    this.itemSize,
    this.itemColour
   }) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Select Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(
              builder: (context, address, c) {
                return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EshopApp.firestore
                        .collection(EshopApp.collectionUser)
                        .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
                        .collection(EshopApp.subCollectionAddress).snapshots(),

                    builder: (context, snapshot) {
                      return !snapshot.hasData ?
                          Center(child: circularProgress(),)
                          : snapshot.data.docs.length == 0 ?
                          noAddressCard() : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AddressCard(
                            currentIndex: address.count,
                            value: index,
                            addressId: snapshot.data.docs[index].id,
                            totalAmount: widget.totalAmount,
                            itemQty: widget.itemQty,
                            model: AddressModel.fromJson(snapshot.data.docs[index].data()),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 10.0,
          label: Text('Add address'),
          backgroundColor: Colors.deepPurpleAccent,
          icon: Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, route);
          },
            ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.purple.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.add_location_alt_outlined,
            color: Colors.white,),
            SizedBox(height: 8.0,),
            Text('Please add an address for delivery'),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int itemQty;
  final String itemSize;
  final Color itemColour;
  final int currentIndex;
  final int value;

  AddressCard({
    Key key,
  this.model,
  this.addressId,
  this.totalAmount,
  this.itemQty,
  this.itemSize,
  this.itemColour,
  this.currentIndex,
  this.value}) : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value),
      child: Card(
        color: Colors.purpleAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    Provider.of<AddressChanger>(
                        context,
                        listen: false)
                        .displayResult(value);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: 'Name',),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: 'Phone',),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: 'Street',),
                              Text(widget.model.street),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: 'City',),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: 'State',),
                              Text(widget.model.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: 'Country',),
                              Text(widget.model.country),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count ?
                WideButton(
                  message: 'Proceed',
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (c) => OrderPayment(
                        addressId: widget.addressId,
                        totalAmount: widget.totalAmount,
                        itemQty: widget.itemQty,
                        itemSize: widget.itemSize,
                        itemColour: widget.itemColour,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ) : Container(),
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}