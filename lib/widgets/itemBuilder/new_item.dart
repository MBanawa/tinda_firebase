import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tinda/widgets/customTextField.dart';

class NewItem extends StatefulWidget {
  final String category;
  final String barcode;

  NewItem({@required this.category, this.barcode});
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var _itemNameController = TextEditingController();
  var _itemQuantityController = TextEditingController();
  var _itemBuyDateController = TextEditingController();
  var _itemSupplierController = TextEditingController();
  var _itemBuyPriceController = TextEditingController();
  var _itemSellPriceController = TextEditingController();

  File imageFile;

  pickImage(ImageSource imageSource) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: imageSource);
    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            'Item Image',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Take a Picture',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () => pickImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text(
                'Select from Gallery',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () => pickImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Item',
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
                height: MediaQuery.of(context).size.height * 1.4,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          takeImage(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Colors.teal.shade300,
                                    image: imageFile == null
                                        ? DecorationImage(
                                            image: ExactAssetImage(
                                                'assets/images/camera.png',
                                                scale: 8.0),
                                            fit: BoxFit.scaleDown,
                                          )
                                        : DecorationImage(
                                            image: FileImage(imageFile),
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    'Barcode:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade800,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  margin:
                                      EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                  child: Center(
                                      child: Text(
                                    widget.barcode == null
                                        ? 'No Barcode'
                                        : widget.barcode,
                                    style: TextStyle(
                                        color: Colors.teal.shade100,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    'Category:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade800,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  margin:
                                      EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                  child: Center(
                                      child: Text(
                                    widget.category == null
                                        ? 'null'
                                        : widget.category,
                                    style: TextStyle(
                                        color: Colors.teal.shade100,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        controller: _itemNameController,
                        hintText: 'Enter the item\'s name here..',
                        isObscure: false,
                      ),
                      CustomTextField(
                        controller: _itemQuantityController,
                        hintText: 'How many pieces are you adding?',
                        isObscure: false,
                      ),
                      CustomTextField(
                        controller: _itemBuyDateController,
                        hintText: 'When did you buy the item?',
                        isObscure: false,
                      ),
                      CustomTextField(
                        controller: _itemSupplierController,
                        hintText: 'Where did you buy the item?',
                        isObscure: false,
                      ),
                      CustomTextField(
                        controller: _itemBuyPriceController,
                        hintText: 'How much did you buy the item for?',
                        isObscure: false,
                      ),
                      CustomTextField(
                        controller: _itemSellPriceController,
                        hintText: 'How much will you sell the item for?',
                        isObscure: false,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 16,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          color: Colors.yellow.shade900,
                          onPressed: () {
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
