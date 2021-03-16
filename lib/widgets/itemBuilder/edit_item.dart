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
  Stream supplierstream;
  // int _selectedIndex;
  String _removeDocId;
  int _quantity;
  int _remainingQuantity = 0;
  var _isLoading;
  final dataKey = GlobalKey();

  // _onSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _setValues();
    _firstIn();
  }

  CollectionReference itemcollection =
      FirebaseFirestore.instance.collection('items');

//find first stock in supplier database with quantity greater than 0
  _firstIn() async {
    CollectionReference docRef =
        itemcollection.doc(widget.itemId).collection('suppliers');
    var listOfDocs = await docRef
        .where('itemId', isEqualTo: widget.itemId)
        .where('quantity', isGreaterThan: 0)
        .get();

    var docs = listOfDocs.docs;

    docs.sort((prev, next) => (prev.data()['entryDate'] as Timestamp)
        .compareTo(next.data()['entryDate'] as Timestamp));

    final desiredDocId = docs.first.id;

    setState(() {
      _removeDocId = desiredDocId;
    });

    // get quantity of firstIn
    getQuantity(widget.itemId, _removeDocId);
  }

  void getQuantity(String itemId, String docId) async {
    DocumentReference documentReference =
        itemcollection.doc(itemId).collection('suppliers').doc(docId);

    await documentReference.get().then((value) {
      _quantity = value.data()['quantity'];
    });
  }

  //remove user entered quantity from the firstIn quantity
  void _firstOut() {
    var _removeQuantity = int.parse(_editItemQuantityController.text.trim());

    final itemCollection =
        FirebaseFirestore.instance.collection('items').doc(widget.itemId);

    if (_quantity < _removeQuantity) {
      _remainingQuantity = _removeQuantity - _quantity;
      var xQuantity = _quantity - _remainingQuantity;
      do {
        itemCollection.collection('suppliers').doc(_removeDocId).update({
          'quantity': _quantity - xQuantity,
        });

        _firstIn();
      } while (_remainingQuantity > 0);
    } else {
      itemCollection.collection('suppliers').doc(_removeDocId).update({
        'quantity': _quantity - _removeQuantity,
      });
    }
  }

  _setValues() {
    setState(() {
      supplierstream = itemcollection
          .doc(widget.itemId)
          .collection('suppliers')
          .orderBy('entryDate')
          .snapshots();
    });
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
    Scrollable.ensureVisible(dataKey.currentContext);
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 1000), () async {
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
        FirebaseFirestore.instance
            .collection('items')
            .doc(widget.itemId)
            .update({
          'quantity': (int.parse(widget.itemQuantity) +
                  int.parse(_editItemQuantityController.text.trim()))
              .toString(),
          'itemImage': imageFile != null ? url : widget.itemImage,
          'supplier': _editItemSupplierController.text.trim(),
          'buyDate': _editItemBuyDateController.text.trim(),
          'buyPrice': double.parse(_editItemBuyPriceController.text.trim()),
          'sellPrice': double.parse(_editItemSellPriceController.text.trim()),
        });

        _supplierDB(widget.itemId, widget.itemName);
        _sellPriceDB(widget.itemId, widget.itemName);
      } else if (widget.option == 'remove') {
        _firstOut();

        FirebaseFirestore.instance
            .collection('items')
            .doc(widget.itemId)
            .update({
          'quantity': int.parse(widget.itemQuantity) -
              int.parse(_editItemQuantityController.text.trim()),
        });

        final itemCollection = FirebaseFirestore.instance
            .collection('items')
            .doc(widget.itemId)
            .collection('removedData');
        itemCollection.add({
          'entryDate': Timestamp.now(),
          'removeReason': _removeReasonController.text.trim(),
          'buyPrice': double.parse(widget.buyPrice),
          'sellPrice': double.parse(widget.sellPrice),
          'supplier': widget.supplier,
          'itemId': widget.itemId,
          'itemName': widget.itemName,
        });
      } else {
        //TODO: Edit supplier and price as well
        FirebaseFirestore.instance
            .collection('items')
            .doc(widget.itemId)
            .update({
          'barcode': _qrCode != null ? _qrCode : widget.barcode,
          'itemName': _editItemNameController.text.trim(),
          'quantity': int.parse(_editItemQuantityController.text.trim()),
          'itemImage': imageFile != null ? url : widget.itemImage,
          'supplier': _editItemSupplierController.text.trim(),
          'buyDate': _editItemBuyDateController.text.trim(),
          'buyPrice': double.parse(_editItemBuyPriceController.text.trim()),
          'sellPrice': double.parse(_editItemSellPriceController.text.trim()),
        });
      }

      Navigator.pop(context, widget.option);
      imageFile = null;
      _editItemNameController.clear();
      _editItemQuantityController.clear();
      _editItemBuyDateController.clear();
      _editItemSupplierController.clear();
      _editItemBuyPriceController.clear();
      _editItemSellPriceController.clear();
    });
  }

  void _supplierDB(String itemId, String itemName) {
    final itemCollection =
        FirebaseFirestore.instance.collection('items').doc(itemId);

    itemCollection.collection('suppliers').add({
      'entryDate': Timestamp.now(),
      'supplier': _editItemSupplierController.text.trim(),
      'buyDate': _editItemBuyDateController.text.trim(),
      'buyPrice': double.parse(_editItemBuyPriceController.text.trim()),
      'quantity': int.parse(_editItemQuantityController.text.trim()),
      'itemId': itemId,
      'itemName': itemName,
    });
  }

  void _sellPriceDB(
    String itemId,
    String itemName,
  ) {
    final itemCollection =
        FirebaseFirestore.instance.collection('items').doc(itemId);
    itemCollection.collection('sellprice').add({
      'entryDate': Timestamp.now(),
      'buyDate': _editItemBuyDateController.text.trim(),
      'buyPrice': double.parse(_editItemBuyPriceController.text.trim()),
      'sellPrice': double.parse(_editItemSellPriceController.text.trim()),
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
        key: dataKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isLoading == true
              ? Container(
                  alignment: Alignment.center,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.teal[600]),
                    backgroundColor: Colors.white,
                  ),
                )
              : Container(),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height * 1.8,
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
                                    'Please type the reason for removing: \n(Expired, rat damage, defective, etc...)',
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
                                    widget.option == 'add'
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
                                    widget.option == 'add'
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
                                    widget.option == 'add'
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
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // //TODO: if there's only 1 line, no need to select. automatically add document id to _selectedIdToRemove
                      // widget.option != 'remove'
                      //     ? Container()
                      //     : Container(
                      //         height: 350,
                      //         color: Colors.black54,
                      //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                      //         child: SingleChildScrollView(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.fromLTRB(
                      //                     8.0, 0.0, 8.0, 0.0),
                      //                 child: Text(
                      //                   'Which stock would you like to deduct?',
                      //                   style: TextStyle(
                      //                       fontSize: 18,
                      //                       color: Colors.white,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ),
                      //               StreamBuilder<QuerySnapshot>(
                      //                 stream: supplierstream,
                      //                 builder: (ctx, supplierSnap) {
                      //                   if (supplierSnap.connectionState ==
                      //                       ConnectionState.waiting) {
                      //                     return Center(
                      //                       child: CircularProgressIndicator(),
                      //                     );
                      //                   }

                      //                   final supplierDocs =
                      //                       supplierSnap.data.docs;

                      //                   return ListView.builder(
                      //                       scrollDirection: Axis.vertical,
                      //                       shrinkWrap: true,
                      //                       physics: BouncingScrollPhysics(),
                      //                       itemCount: supplierDocs.length,
                      //                       itemBuilder: (context, index) {
                      //                         return Card(
                      //                           shape: RoundedRectangleBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(6),
                      //                           ),
                      //                           margin: EdgeInsets.all(8),
                      //                           child: GestureDetector(
                      //                             onTap: () {
                      //                               _onSelected(index);
                      //                               var errorMessage =
                      //                                   'There are only ${supplierDocs[index].data()['quantity']} pieces left in this stock. Please select a different stock item.';
                      //                               int.parse(_editItemQuantityController
                      //                                           .text) >
                      //                                       supplierDocs[index]
                      //                                               .data()[
                      //                                           'quantity']
                      //                                   ? showErrorDialog(
                      //                                       context,
                      //                                       errorMessage)
                      //                                   : setState(() {
                      //                                       _removeDocId =
                      //                                           supplierDocs[
                      //                                                   index]
                      //                                               .id;
                      //                                       _quantity =
                      //                                           supplierDocs[
                      //                                                       index]
                      //                                                   .data()[
                      //                                               'quantity'];
                      //                                     });
                      //                             },
                      //                             child: Container(
                      //                               decoration: BoxDecoration(
                      //                                   color: _selectedIndex !=
                      //                                               null &&
                      //                                           _selectedIndex ==
                      //                                               index
                      //                                       ? Colors.white
                      //                                       : Colors.grey[400],
                      //                                   borderRadius:
                      //                                       BorderRadius.all(
                      //                                           Radius.circular(
                      //                                               6))),
                      //                               child: Padding(
                      //                                 padding: const EdgeInsets
                      //                                         .fromLTRB(
                      //                                     12, 8, 0, 10),
                      //                                 child: Row(
                      //                                   mainAxisAlignment:
                      //                                       MainAxisAlignment
                      //                                           .spaceBetween,
                      //                                   children: <Widget>[
                      //                                     Expanded(
                      //                                       child: Column(
                      //                                         mainAxisAlignment:
                      //                                             MainAxisAlignment
                      //                                                 .center,
                      //                                         crossAxisAlignment:
                      //                                             CrossAxisAlignment
                      //                                                 .start,
                      //                                         children: [
                      //                                           Text(
                      //                                             supplierDocs[
                      //                                                         index]
                      //                                                     .data()[
                      //                                                 'supplier'],
                      //                                             style:
                      //                                                 TextStyle(
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               fontSize:
                      //                                                   18,
                      //                                               color: _selectedIndex !=
                      //                                                           null &&
                      //                                                       _selectedIndex ==
                      //                                                           index
                      //                                                   ? Colors
                      //                                                       .teal
                      //                                                       .shade800
                      //                                                   : Colors
                      //                                                       .grey[900],
                      //                                             ),
                      //                                           ),
                      //                                           Text(
                      //                                             'You purchased on: ${supplierDocs[index].data()['buyDate']} \nPurchase price:  PHP ${supplierDocs[index].data()['buyPrice'].toStringAsFixed(2)}',
                      //                                             style:
                      //                                                 TextStyle(
                      //                                               fontSize:
                      //                                                   10,
                      //                                               color: _selectedIndex !=
                      //                                                           null &&
                      //                                                       _selectedIndex ==
                      //                                                           index
                      //                                                   ? Colors
                      //                                                       .orange
                      //                                                       .shade400
                      //                                                   : Colors
                      //                                                       .grey[900],
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                     Padding(
                      //                                       padding:
                      //                                           const EdgeInsets
                      //                                                   .fromLTRB(
                      //                                               0,
                      //                                               4,
                      //                                               16,
                      //                                               0),
                      //                                       child: Text(
                      //                                         'In Stock: ${supplierDocs[index].data()['quantity']}',
                      //                                         style: TextStyle(
                      //                                             color: Colors
                      //                                                     .grey[
                      //                                                 900]),
                      //                                       ),
                      //                                     ),
                      //                                     Padding(
                      //                                       padding:
                      //                                           const EdgeInsets
                      //                                               .all(8.0),
                      //                                       child: Icon(
                      //                                         _selectedIndex !=
                      //                                                     null &&
                      //                                                 _selectedIndex ==
                      //                                                     index
                      //                                             ? Icons
                      //                                                 .check_circle
                      //                                             : Icons
                      //                                                 .check_circle_outline,
                      //                                         color: _selectedIndex !=
                      //                                                     null &&
                      //                                                 _selectedIndex ==
                      //                                                     index
                      //                                             ? Colors.teal
                      //                                             : Colors.grey[
                      //                                                 900],
                      //                                       ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         );
                      //                       });
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //         )),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 60,
                          child: ElevatedButton(
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
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green;
                                  return Colors.yellow.shade900;
                                })),
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
