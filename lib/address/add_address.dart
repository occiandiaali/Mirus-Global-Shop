import 'package:fluttertoast/fluttertoast.dart';
import 'package:mirus_global/Widgets/customAppBar.dart';
import 'package:mirus_global/config/config.dart';
//import 'package:mirus_global/widgets/customAppBar.dart';
//import 'package:mirus_global/models/address.dart';
import 'package:flutter/material.dart';
import 'package:mirus_global/models/address.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if(formKey.currentState.validate()) {
                final model = AddressModel(
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  street: streetAddressController.text.trim(),
                  city: cityController.text.trim(),
                  state: stateController.text.trim(),
                  country: countryController.text.trim(),
                ).toJson();
                // add to fire store
                EshopApp.firestore.collection(EshopApp.collectionUser)
                    .doc(EshopApp.sharedPreferences.getString(EshopApp.userUID))
                    .collection(EshopApp.subCollectionAddress)
                    .doc(DateTime.now().millisecondsSinceEpoch.toString())
                    .set(model)
                    .then((v) {
                  Fluttertoast.showToast(msg: 'Address added.');
                      FocusScope.of(context).requestFocus(FocusNode());
                      formKey.currentState.reset();
                });
              }
            },
            label: Text('Done'),
        backgroundColor: Colors.deepPurpleAccent,
        icon: Icon(Icons.check_outlined),),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'New Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name e.g. Amaka Musa Segun",
                      controller: nameController,
                    ),
                    MyTextField(
                      hint: "Phone e.g. +234-81122334455",
                      controller: phoneController,
                    ),
                    MyTextField(
                      hint: "Street e.g. 10, Good street",
                      controller: streetAddressController,
                    ),
                    MyTextField(
                      hint: "City (or Local government area name)",
                      controller: cityController,
                    ),
                    MyTextField(
                      hint: "State",
                      controller: stateController,
                    ),
                    MyTextField(
                      hint: "Country",
                      controller: countryController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // address class


class MyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;

  MyTextField({
    Key key,
    this.hint,
    this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(
            hintText: hint),
        validator: (value) => value.isEmpty ?
        "Field is required" : null,
      ),
    );
  }
}