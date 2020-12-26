import 'package:flutter/foundation.dart';

class Barcode {
  final String barcode;

  Barcode(this.barcode);
}

class BarcodeProvider with ChangeNotifier {
  Barcode _barcode;

  Barcode get getBarcode {
    return _barcode;
  }

  void acceptBarcode(String acceptedbc) {
    final bc = Barcode(acceptedbc);
    _barcode = bc;
    notifyListeners();
  }
}
