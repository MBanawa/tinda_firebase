import 'package:flutter/foundation.dart';

class Category {
  final String categoryId;

  Category(this.categoryId);
}

class CategoryProvider with ChangeNotifier {
  Category _category;

  Category get getCategory {
    return _category;
  }

  void acceptCategory(String acceptedCatId) {
    final categ = Category(acceptedCatId);
    _category = categ;
    notifyListeners();
  }
}
