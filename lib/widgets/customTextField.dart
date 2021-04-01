import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObscured = true;

  CustomTextField({
    Key key,
    this.controller,
    this.data,
    this.hintText,
    this.isObscured,
}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
