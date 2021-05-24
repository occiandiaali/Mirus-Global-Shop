import 'package:flutter/foundation.dart';

class ItemSpecial with ChangeNotifier {
  bool _isItemSpecial = false;
  bool get getIsItemSpecial => _isItemSpecial;

  isItemSpecial(bool b) async {
    _isItemSpecial = b;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}