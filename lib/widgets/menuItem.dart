import 'package:flutter/material.dart';

class MenuItem {
  String menuVal;
  IconData iconVal;

  MenuItem(this.menuVal, this.iconVal);
}

final List<MenuItem> menuitems = [
  MenuItem('Edit', Icons.edit),
  MenuItem('Delete', Icons.delete),
];
