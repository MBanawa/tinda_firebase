import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewCategory extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _controller = new TextEditingController();
  var _enteredText = '';

  void _createNewCategory() async {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('categories').add({
      'categoryname': _enteredText,
      'createdAt': Timestamp.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
