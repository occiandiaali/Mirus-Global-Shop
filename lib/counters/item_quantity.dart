import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;
  int _qtyInStock = 0;

  int get numberOfItems => _numberOfItems;
  int get qtyInStock => _qtyInStock;

  qtyOfItem(int n) async {
    _numberOfItems = n;
    await Future.delayed(const Duration(milliseconds: 100), () {
    notifyListeners();
    });
  }

  qtyOfItemInStock(int s) async {
    _qtyInStock = s;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

}