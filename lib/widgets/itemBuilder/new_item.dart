import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _selectedItemDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
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
    final pickedFile = await ImagePicker().getImage(
        source: imageSource,
        imageQuality: imageSource == ImageSource.camera ? 20 : 50);
    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          backgroundColor: Colors.teal,
          title: Text(
            'Upload an Image',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Take a Picture',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => pickImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text(
                'Select from Gallery',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => pickImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
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

  _showSnackBar(BuildContext context, message) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.teal.shade900,
      duration: const Duration(milliseconds: 1500),
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  void _saveNewItem() async {
    FocusScope.of(context).unfocus();
    _showSnackBar(context, Text('Saving....'));
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final ref = FirebaseStorage.instance
        .ref()
        .child('itemImage')
        .child(Timestamp.now().millisecondsSinceEpoch.toString() + '.jpg');

    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();

    final itemDoc = await FirebaseFirestore.instance.collection('items').add({
      'userId': user.uid,
      'userName': userData.data()['name'],
      'createdAt': Timestamp.now(),
      'itemName': _itemNameController.text.trim(),
      'barcode': widget.barcode,
      'category': widget.category,
      'quantity': _itemQuantityController.text.trim(),
      'itemImage': url,
      'supplier': _itemSupplierController.text.trim(),
      'buyDate': _itemBuyDateController.text.trim(),
      'buyPrice': _itemBuyPriceController.text.trim(),
      'sellPrice': _itemSellPriceController.text.trim(),
    });

    _supplierDB(itemDoc.id, _itemNameController.text.trim());
    _sellPriceDB(itemDoc.id, _itemNameController.text.trim());

    Navigator.pop(context);
  }

  void _supplierDB(String itemId, String itemName) {
    final itemCollection = FirebaseFirestore.instance.collection('suppliers');

    itemCollection.add({
      'entryDate': Timestamp.now(),
      'supplier': _itemSupplierController.text.trim(),
      'buyDate': _itemBuyDateController.text.trim(),
      'buyPrice': _itemBuyPriceController.text.trim(),
      'quantity': _itemQuantityController.text.trim(),
      'itemId': itemId,
      'itemName': itemName,
    });
  }

  void _sellPriceDB(
    String itemId,
    String itemName,
  ) {
    final itemCollection = FirebaseFirestore.instance.collection('sellprice');
    itemCollection.add({
      'entryDate': Timestamp.now(),
      'buyDate': _itemBuyDateController.text.trim(),
      'buyPrice': _itemBuyPriceController.text.trim(),
      'sellPrice': _itemSellPriceController.text.trim(),
      'itemId': itemId,
      'itemName': itemName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
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
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          takeImage(context);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 15.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Center(
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.teal.shade300,
                                backgroundImage: imageFile == null
                                    ? null
                                    : FileImage(imageFile),
                                child: Image.asset(
                                  'assets/images/camera.png',
                                  width: 50,
                                  height: 50,
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
                          _saveNewItem();
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
                              _saveNewItem();
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
