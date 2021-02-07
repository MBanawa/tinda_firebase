import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tinda/screens/generate_qrcode_screen.dart';

import 'package:tinda/widgets/customTextField.dart';

class EditItem extends StatefulWidget {
  final String option;
  final String itemId;
  final String category;
  final String barcode;
  final String itemName;
  final String itemQuantity;
  final String itemImage;
  final String buyDate;
  final String supplier;
  final String buyPrice;
  final String sellPrice;

  EditItem({
    @required this.option,
    @required this.itemId,
    @required this.category,
    @required this.barcode,
    @required this.itemName,
    @required this.itemQuantity,
    @required this.itemImage,
    @required this.buyDate,
    @required this.supplier,
    @required this.buyPrice,
    @required this.sellPrice,
  });

  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  var _editItemNameController = TextEditingController();
  var _editItemQuantityController = TextEditingController();
  var _editItemBuyDateController = TextEditingController();
  var _editItemSupplierController = TextEditingController();
  var _editItemBuyPriceController = TextEditingController();
  var _editItemSellPriceController = TextEditingController();
  var _removeReasonController = TextEditingController();
  FocusNode _quantFocusNode = FocusNode();
  FocusNode _buyDateFocusNode = FocusNode();
  FocusNode _supplierFocusNode = FocusNode();
  FocusNode _buyPriceFocusNode = FocusNode();
  FocusNode _sellPriceFocusNode = FocusNode();
  FocusNode _reasonFocusNode = FocusNode();
  File imageFile;
  DateTime _dateTime = DateTime.now();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String _qrCode;
  bool _dismiss = false;
  @override
  void initState() {
    super.initState();
    _setValues();
    _test();
  }

  _setValues() {
    if (widget.option == 'add' || widget.option == 'remove') {
      _editItemQuantityController.clear();
      _editItemBuyDateController.clear();
      _editItemSupplierController.clear();
      _editItemBuyPriceController.clear();
      _editItemSellPriceController.clear();
    } else {
      _editItemNameController.text = widget.itemName;
      _editItemQuantityController.text = widget.itemQuantity;
      _editItemBuyDateController.text = widget.buyDate;
      _editItemSupplierController.text = widget.supplier;
      _editItemBuyPriceController.text = widget.buyPrice;
      _editItemSellPriceController.text = widget.sellPrice;
    }
  }

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
        _editItemBuyDateController.text =
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

  _showSnackBar(
    BuildContext context,
    message,
  ) {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.green,
      duration: const Duration(milliseconds: 3000),
    );
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  void _editItem() async {
    FocusScope.of(context).unfocus();
    _showSnackBar(context, Text('Saving, please wait....'));
    var url;

    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('itemImage')
          .child(Timestamp.now().millisecondsSinceEpoch.toString() + '.jpg');

      await ref.putFile(imageFile);
      url = await ref.getDownloadURL();
    }

    if (widget.option == 'add') {
      FirebaseFirestore.instance.collection('items').doc(widget.itemId).update({
        'quantity': (int.parse(widget.itemQuantity) +
                int.parse(_editItemQuantityController.text.trim()))
            .toString(),
        'itemImage': imageFile != null ? url : widget.itemImage,
        'supplier': _editItemSupplierController.text.trim(),
        'buyDate': _editItemBuyDateController.text.trim(),
        'buyPrice': _editItemBuyPriceController.text.trim(),
        'sellPrice': _editItemSellPriceController.text.trim(),
      });

      _supplierDB(widget.itemId, _editItemNameController.text.trim());
      _sellPriceDB(widget.itemId, _editItemNameController.text.trim());
    } else if (widget.option == 'remove') {
      FirebaseFirestore.instance.collection('items').doc(widget.itemId).update({
        'quantity': (int.parse(widget.itemQuantity) -
                int.parse(_editItemQuantityController.text.trim()))
            .toString(),
      });

      //TODO: first in first out or last in first out for prices and supplier?
      final itemCollection =
          FirebaseFirestore.instance.collection('removedData');
      itemCollection.add({
        'entryDate': Timestamp.now(),
        'removeReason': _removeReasonController.text.trim(),
        'buyPrice': widget.buyPrice,
        'sellPrice': widget.sellPrice,
        'supplier': widget.supplier,
        'itemId': widget.itemId,
        'itemName': widget.itemName,
      });
    } else {
      //TODO: Edit supplier and price as well
      FirebaseFirestore.instance.collection('items').doc(widget.itemId).update({
        'barcode': _qrCode != null ? _qrCode : widget.barcode,
        'itemName': _editItemNameController.text.trim(),
        'quantity': _editItemQuantityController.text.trim(),
        'itemImage': imageFile != null ? url : widget.itemImage,
        'supplier': _editItemSupplierController.text.trim(),
        'buyDate': _editItemBuyDateController.text.trim(),
        'buyPrice': _editItemBuyPriceController.text.trim(),
        'sellPrice': _editItemSellPriceController.text.trim(),
      });
    }

    Navigator.pop(context);
    imageFile = null;
    _editItemNameController.clear();
    _editItemQuantityController.clear();
    _editItemBuyDateController.clear();
    _editItemSupplierController.clear();
    _editItemBuyPriceController.clear();
    _editItemSellPriceController.clear();
  }

  //TODO: https://www.youtube.com/watch?v=fy-rCZVcw78&ab_channel=1ManStartup

  void _test() {
    final supplier = FirebaseFirestore.instance
        .collection('suppliers')
        .where('itemId', isEqualTo: widget.itemId)
        .where('entryDate', isNotEqualTo: 0)
        // .where('quantity', isGreaterThan: 0)
        .orderBy('entryDate')
        .limit(1)
        .get();
    supplier.then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((f) {
            print('Doc ID:' + f.reference.id);
          })
        });
  }

  void _supplierDB(String itemId, String itemName) {
    final itemCollection = FirebaseFirestore.instance.collection('suppliers');

    itemCollection.add({
      'entryDate': Timestamp.now(),
      'supplier': _editItemSupplierController.text.trim(),
      'buyDate': _editItemBuyDateController.text.trim(),
      'buyPrice': _editItemBuyPriceController.text.trim(),
      'quantity': _editItemQuantityController.text.trim(),
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
      'buyDate': _editItemBuyDateController.text.trim(),
      'buyPrice': _editItemBuyPriceController.text.trim(),
      'sellPrice': _editItemSellPriceController.text.trim(),
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
          widget.option == 'add'
              ? 'Add Stocks for ${widget.itemName}'
              : widget.option == 'remove'
                  ? 'Remove Stocks for ${widget.itemName}'
                  : 'Edit Details for ${widget.itemName}',
          softWrap: true,
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
                                backgroundImage: imageFile != null
                                    ? FileImage(imageFile)
                                    : NetworkImage(widget.itemImage),
                                child: widget.option == 'add' ||
                                        widget.option == 'remove'
                                    ? null
                                    : Image.asset(
                                        'assets/images/camera.png',
                                        width: 50,
                                        height: 50,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      widget.option == 'add' || widget.option == 'remove'
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 0.0, 8.0, 0.0),
                                        child: Text(
                                          _qrCode != null
                                              ? 'QR Name:'
                                              : 'Barcode:',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade800,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        margin: EdgeInsets.fromLTRB(
                                            8.0, 0.0, 8.0, 8.0),
                                        child: Center(
                                            child: Text(
                                          widget.barcode == null
                                              ? _qrCode == null
                                                  ? 'No Barcode'
                                                  : _qrCode
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0)),
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        margin: EdgeInsets.fromLTRB(
                                            8.0, 0.0, 8.0, 8.0),
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
                      widget.option == 'add' || widget.option == 'remove'
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  widget.barcode == null && _qrCode == null
                                      ? _dismiss == false
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0)),
                                              ),
                                              margin: EdgeInsets.all(14),
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Notice:',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .red.shade400,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _dismiss = true;
                                                              });
                                                            },
                                                            child: Icon(
                                                                Icons.close)),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    'No Barcode detected. \nDo you want to generate a QR Code for this item?',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .yellow.shade900,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6.0)),
                                                    ),
                                                    width: double.infinity,
                                                    child: FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          GenerateQr()))
                                                              .then((value) {
                                                            setState(() {
                                                              _qrCode = value;
                                                            });
                                                          });
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox()
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Item Name:',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: _editItemNameController,
                                    keyboardType: TextInputType.text,
                                    hintText: 'Enter the item\'s name here..',
                                    isObscure: false,
                                    onSubmitted: (_) {
                                      widget.option == 'remove'
                                          ? FocusScope.of(context)
                                              .requestFocus(_reasonFocusNode)
                                          : FocusScope.of(context)
                                              .requestFocus(_quantFocusNode);
                                    },
                                  )
                                ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(
                          widget.option == 'add' || widget.option == 'remove'
                              ? 'How many ${widget.itemName} will you ${widget.option}? \n(Current stocks: ${widget.itemQuantity})'
                              : 'Quantity:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomTextField(
                        focusNode: _quantFocusNode,
                        keyboardType: TextInputType.number,
                        controller: _editItemQuantityController,
                        hintText:
                            widget.option == 'add' || widget.option == 'remove'
                                ? 'How many pieces will you ${widget.option}?'
                                : 'How many pieces are you adding?',
                        isObscure: false,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_buyDateFocusNode);
                        },
                      ),
                      widget.option == 'remove'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    'Please select reason for removing: \n(Expired, rat damage, defective, etc...)',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CustomTextField(
                                  focusNode: _reasonFocusNode,
                                  keyboardType: TextInputType.text,
                                  controller: _removeReasonController,
                                  hintText: 'Why are you removing stocks?',
                                  isObscure: false,
                                  onSubmitted: (_) {},
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    'Purchase Date:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CustomTextField(
                                  focusNode: _buyDateFocusNode,
                                  keyboardType: TextInputType.datetime,
                                  controller: _editItemBuyDateController,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    widget.option == 'add' ||
                                            widget.option == 'remove'
                                        ? 'Supplier Name: \n(Last Supplier: ${widget.supplier})'
                                        : 'Supplier Name:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CustomTextField(
                                  focusNode: _supplierFocusNode,
                                  keyboardType: TextInputType.text,
                                  controller: _editItemSupplierController,
                                  hintText: 'Where did you buy the item?',
                                  isObscure: false,
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_buyPriceFocusNode);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    widget.option == 'add' ||
                                            widget.option == 'remove'
                                        ? 'Purchase Price: \n(Previous Purchase Price: PHP ${double.parse(widget.buyPrice).toStringAsFixed(2)})'
                                        : 'Purchase Price:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CustomTextField(
                                  focusNode: _buyPriceFocusNode,
                                  keyboardType: TextInputType.number,
                                  controller: _editItemBuyPriceController,
                                  hintText:
                                      'How much did you buy the item for?',
                                  isObscure: false,
                                  onSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_sellPriceFocusNode);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Text(
                                    widget.option == 'add' ||
                                            widget.option == 'remove'
                                        ? 'Sell Price: \n(Previous Sell Price: PHP ${double.parse(widget.sellPrice).toStringAsFixed(2)})'
                                        : 'Sell Price:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CustomTextField(
                                  focusNode: _sellPriceFocusNode,
                                  keyboardType: TextInputType.number,
                                  controller: _editItemSellPriceController,
                                  hintText:
                                      'How much will you sell the item for?',
                                  isObscure: false,
                                  onSubmitted: (_) {
                                    _editItem();
                                  },
                                ),
                              ],
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
                              _editItem();
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
