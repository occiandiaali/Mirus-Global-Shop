import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ItemColour with ChangeNotifier {
  String _colorOfItems = " ";
  String get colorOfItems => _colorOfItems;

  colourOfItem(String c) async {
    _colorOfItems = c;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}