import 'package:flutter/material.dart';

import 'package:tinda/widgets/categoryBuilder/new_category.dart';

class InventoryScreen extends StatelessWidget {
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
                onPressed: () {},
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewCategory()));
        },
      ),
    );
  }
}
