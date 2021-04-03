import 'package:flutter/foundation.dart';
import 'package:mirus_global/config/config.dart';

class CartItemCounter extends ChangeNotifier{
  int _counter = EshopApp
      .sharedPreferences
      .getStringList(EshopApp.userCartList).length - 1;
  int get count => _counter;
}