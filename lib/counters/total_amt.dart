import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0.0;

  double get totalAmount => _totalAmount;

  display(double n) async {
    _totalAmount = n;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

}