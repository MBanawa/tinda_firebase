import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  FocusNode _quantFocusNode = FocusNode();
  FocusNode _buyDateFocusNode = FocusNode();
  FocusNode _supplierFocusNode = FocusNode();
  FocusNode _buyPriceFocusNode = FocusNode();
  FocusNode _sellPriceFocusNode = FocusNode();
  File imageFile;

  DateTime _dateTime = DateTime.now();

  _selectedItemDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _itemBuyDateController.text =
            DateFormat('dd-MMM-yyyy').format(_pickedDate);
      });
    }
  }

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
            'Upload an Image',
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

  void _saveNewItem(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a New Item',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fit: BoxFit.cover,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Item Name:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        controller: _itemNameController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter the item\'s name here..',
                        isObscure: false,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_quantFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Quantity:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _quantFocusNode,
                        keyboardType: TextInputType.number,
                        controller: _itemQuantityController,
                        hintText: 'How many pieces are you adding?',
                        isObscure: false,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_buyDateFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Purchase Date:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _buyDateFocusNode,
                        keyboardType: TextInputType.datetime,
                        controller: _itemBuyDateController,
                        hintText: 'When did you buy the item?',
                        isObscure: false,
                        onTap: () {
                          _selectedItemDate(context);
                        },
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_supplierFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Supplier Name:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _supplierFocusNode,
                        keyboardType: TextInputType.text,
                        controller: _itemSupplierController,
                        hintText: 'Where did you buy the item?',
                        isObscure: false,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_buyPriceFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Purchase Price:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _buyPriceFocusNode,
                        keyboardType: TextInputType.number,
                        controller: _itemBuyPriceController,
                        hintText: 'How much did you buy the item for?',
                        isObscure: false,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_sellPriceFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          'Sell Price:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _sellPriceFocusNode,
                        keyboardType: TextInputType.number,
                        controller: _itemSellPriceController,
                        hintText: 'How much will you sell the item for?',
                        isObscure: false,
                        onSubmitted: (_) {
                          _saveNewItem(context);
                        },
                      ),
                      SizedBox(
                        height: 15,
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
          ),
        ],
      ),
    );
  }
}
