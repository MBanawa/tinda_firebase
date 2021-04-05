//TODO: FINISH THIS AND THE REPORTING SCREEN ASAP. WE NEED TO PRESENT IT TO BOSS LLOYD.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinda/models/cashier/cashier_item.dart';
import 'package:tinda/services/cashier/sales.dart';
import 'package:tinda/widgets/shared-widgets/images/cached_image_widget.dart';

import 'cashier/qr_code_scanner.dart';
import 'cashier/search_item.dart';

class CashierScreen extends StatefulWidget {
  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  double _smallFontSize = 12;
  double total = 0;
  double cash = 0;
  bool loading = false;

  double _medFontSize = 16;

  Map<String, CashierItem> selectedItems = {};

  CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  addItemToSummary(String id, CashierItem item) {
    setState(() {
      total += item.price * item.quantity;
      selectedItems.update(
        id,
        (value) => value..quantity += item.quantity,
        ifAbsent: () => item,
      );
    });
  }

  Future<bool> verifyQRCode(String code) async {
    QuerySnapshot snapshot = await itemsCollection
        .where(
          'barcode',
          isEqualTo: code,
        )
        .where(
          'userId',
          isEqualTo: FirebaseAuth.instance.currentUser.uid,
        )
        .get();
    if (snapshot.docs.length > 0) {
      bool submitted = false;
      bool continueScanning = false;
      TextEditingController _quantityController = TextEditingController(
        text: '1',
      );
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Item quantity'),
          content: TextField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              hintText: 'Please enter Item quantity',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitted = true;
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                continueScanning = true;
                submitted = true;
                Navigator.pop(context);
              },
              child: Text('Scan more'),
            ),
          ],
        ),
      );
      if (!submitted) return false;
      int quantity = int.tryParse(_quantityController.text) ?? 1;
      setState(() {
        total += snapshot.docs.first.data()['sellPrice'] * quantity;
        selectedItems.update(
          snapshot.docs.first.id,
          (old) => CashierItem(
            title: snapshot.docs.first.data()['itemName'],
            quantity: old.quantity + quantity,
            price: snapshot.docs.first.data()['sellPrice'],
          ),
          ifAbsent: () => CashierItem(
            title: snapshot.docs.first.data()['itemName'],
            quantity: quantity,
            price: snapshot.docs.first.data()['sellPrice'],
          ),
        );
      });
      if (continueScanning)
        Future.delayed(Duration(milliseconds: 2000)).then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QRCodeScannerPage(
                verifyCallback: verifyQRCode,
                quitCallback: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner_sharp),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QRCodeScannerPage(
              verifyCallback: verifyQRCode,
              quitCallback: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cashier'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.save, size: 30),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await declareSale(selectedItems, cash, total);
                setState(() {
                  selectedItems = {};
                  total = 0;
                  cash = 0;
                  loading = false;
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 21),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Inday\'s General Merch',
                                    style: TextStyle(fontSize: _smallFontSize),
                                  ),
                                  Text(
                                    'Angeles City, 2009',
                                    style: TextStyle(fontSize: _smallFontSize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'INVOICE',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'DATE:',
                                  style: TextStyle(
                                    fontSize: _medFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'INVOICE NUM:',
                                  style: TextStyle(
                                    fontSize: _medFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'TIME:',
                                  style: TextStyle(
                                    fontSize: _medFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now()),
                                  style: TextStyle(fontSize: _medFontSize),
                                ),
                                StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                          FirebaseAuth.instance.currentUser.uid,
                                        )
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.hasData
                                            ? (snapshot.data
                                                        .data()['salesCount']
                                                    as int)
                                                .toString()
                                            : 'loading',
                                        style:
                                            TextStyle(fontSize: _medFontSize),
                                      );
                                    }),
                                Text(
                                  DateFormat('hh:mm a').format(DateTime.now()),
                                  style: TextStyle(fontSize: _medFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  //TODO: MAKE SURE TO SAVE SALES TIED TO THE USER ID
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Table(
                      columnWidths: {
                        0: FractionColumnWidth(.5),
                      },
                      border: TableBorder.symmetric(
                        outside: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Container(
                              color: Colors.grey[900],
                              height: 40,
                              child: Center(
                                child: Text(
                                  'ITEMS',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey[900],
                              height: 40,
                              child: Center(
                                child: Text(
                                  'QTY',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey[900],
                              height: 40,
                              child: Center(
                                child: Text(
                                  'PRICE',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey[900],
                              height: 40,
                              child: Center(
                                child: Text(
                                  'TOTAL',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...selectedItems.values
                            .map(
                              (e) => TableRow(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(e.title),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(e.quantity.toString()),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(e.price.toStringAsFixed(1)),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text((e.quantity * e.price)
                                          .toStringAsFixed(1)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.teal,
                          child: Text(
                            'TOTAL',
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.teal,
                          child: Text(
                            'PHP ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            'CASH',
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            'PHP ${cash.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            'CHANGE',
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            'PHP ${(cash - total).toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 16,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchItemView(
                              addToSummary: addItemToSummary,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'SEARCH ITEM',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return Colors.grey[900];
                            })),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 16,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _makePayment,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'PAYMENT',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return Colors.teal;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loading)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color(0x22000000),
                child: Center(
                  child: ImageLoadingWidget(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _makePayment() async {
    TextEditingController _amountController =
        TextEditingController(text: (cash ?? 9).toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment'),
        content: TextField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            hintText: 'Please enter the amount of payment',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cash = double.tryParse(_amountController.text) ?? 0;
              });
              Navigator.pop(context);
            },
            child: Text('Save payment'),
          ),
        ],
      ),
    );
  }
}
