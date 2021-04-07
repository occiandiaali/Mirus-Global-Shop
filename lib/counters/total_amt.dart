import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;

  double get totalAmount => _totalAmount;

  display(double numba) async {
    _totalAmount = numba;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }

}