import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ItemColour with ChangeNotifier {
  Color _colorOfItems = Colors.blue[800];
  Color get colorOfItems => _colorOfItems;

  colourOfItem(Color c) async {
    _colorOfItems = c;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}