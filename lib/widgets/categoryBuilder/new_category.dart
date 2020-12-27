import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:tinda/providers/category_provider.dart';

import 'package:tinda/widgets/customTextField.dart';
import 'package:tinda/widgets/roundIconButton.dart';

class NewCategory extends StatefulWidget {
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  //~~~~~~~~~~Colorpicker
  Color pickerColor = Color(0xff008080);
  Color currentColor = Color(0xff443a49);
  int categcolor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      int colorInt = pickerColor.value;
      categcolor = colorInt;
      print(colorInt);
    });
  }

  static Widget layoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 5,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          children: colors.map((Color color) => child(color)).toList(),
        ),
      ),
    );
  }

  _colorDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Pick a Color'),
            content: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlockPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                      layoutBuilder: layoutBuilder,
                    ),
                    RaisedButton(
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _newCategory() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('categories').add({
      'userId': user.uid,
      'name': userData.data()['name'],
      'categoryname': _categoryNameController.text.trim(),
      'categorydescription': _categoryDescriptionController.text.trim(),
      'categorycolor': categcolor != null ? categcolor : 4278228616,
      'createdAt': Timestamp.now(),
    });

    _categoryNameController.clear();
    _categoryDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Category',
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 4),
                            child: RoundIconButton(
                              onPressed: () {
                                _colorDialog(context);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                              colour: pickerColor,
                              elevation: 6.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Category Color',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Text(
                        'Category Name:',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    CustomTextField(
                      controller: _categoryNameController,
                      hintText: 'Enter a category name here..',
                      isObscure: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      child: Text(
                        'Category Description:',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    CustomTextField(
                      controller: _categoryDescriptionController,
                      hintText: 'Enter a short description here..',
                      isObscure: false,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          color: Colors.yellow.shade900,
                          onPressed: () {
                            _newCategory();
                            Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .acceptCategory(
                                    _categoryNameController.text.trim());
                            Navigator.pop(context, 'Save');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
