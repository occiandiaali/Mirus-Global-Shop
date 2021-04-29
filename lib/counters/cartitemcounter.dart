import 'package:flutter/foundation.dart';
import 'package:mirus_global/config/config.dart';

class CartItemCounter extends ChangeNotifier {

  int counter = EshopApp
      .sharedPreferences
      .getStringList(EshopApp.userCartList)
      .length - 1;

  int get count => counter ?? 0;

  Future<void> displayResult(int v) async {
    counter = v;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }


}