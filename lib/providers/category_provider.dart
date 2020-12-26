import 'package:flutter/foundation.dart';

class Category {
  final String category;

  Category(this.category);
}

class CategoryProvider with ChangeNotifier {
  Category _category;

  Category get getCategory {
    return _category;
  }

  void acceptCategory(String acceptedCat) {
    final bc = Category(acceptedCat);
    _category = bc;
    notifyListeners();
  }
}
