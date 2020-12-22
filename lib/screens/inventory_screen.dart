import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final _controller = new TextEditingController();

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.red,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.green,
                onPressed: () {
                  FirebaseFirestore.instance.collection('categories').add({
                    'categoryname': _categoryNameController.text.trim(),
                    'categorydescription':
                        _categoryDescriptionController.text.trim(),
                  });
                },
                child: Text('Save'),
              ),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a Category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a Description',
                    labelText: 'Description',
                  ),
                ),
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
