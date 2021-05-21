//import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ItemSize with ChangeNotifier {
  String _sizeOfItems = 'Small';
  String get sizeOfItems => _sizeOfItems;

  sizeOfItem(String s) async {
    _sizeOfItems = s;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}