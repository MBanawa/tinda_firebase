import 'package:flutter/material.dart';

class PhoneSize with ChangeNotifier {
  double sizedBoxSize;
  double fontSize;

  void sizeAdjuster(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    if (mediaQuery >= 2040) {
      sizedBoxSize = 20.0;
      fontSize = 25.0;
    } else if (mediaQuery >= 1794) {
      sizedBoxSize = 15.0;
      fontSize = 20.0;
    } else {
      sizedBoxSize = 10.0;
      fontSize = 15.0;
    }
  }
}
