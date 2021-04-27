import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;

  int get numberOfItems => _numberOfItems;

  qtyOfItem(int n) async {
    _numberOfItems = n;
    await Future.delayed(const Duration(milliseconds: 100), () {
    notifyListeners();
    });
  }

}