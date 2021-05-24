//import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ItemSize with ChangeNotifier {
  String _sizeOfItem = " ";
  String get getSizeOfItem => _sizeOfItem;

  sizeOfItem(String s) async {
    _sizeOfItem = s;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}