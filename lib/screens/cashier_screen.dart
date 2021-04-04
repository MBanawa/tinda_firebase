//TODO: FINISH THIS AND THE REPORTING SCREEN ASAP. WE NEED TO PRESENT IT TO BOSS LLOYD.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinda/models/cashier/cashier_item.dart';

import 'cashier/qr_code_scanner.dart';

class CashierScreen extends StatefulWidget {
  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  double _smallFontSize = 12;
  double total = 0;
  double cash = 0;

  double _medFontSize = 16;

  List<CashierItem> selectedItems = [];

  Future<bool> verifyQRCode(String code) async {
    CollectionReference itemsCollection =
        FirebaseFirestore.instance.collection('items');
    QuerySnapshot snapshot = await itemsCollection
        .where(
          'barcode',
          isEqualTo: code,
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
              hintText: 'Please enter ItenQuantity',
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
        selectedItems.add(
          CashierItem(
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
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                            '19-Feb-2021',
                            style: TextStyle(fontSize: _medFontSize),
                          ),
                          Text(
                            '000258',
                            style: TextStyle(fontSize: _medFontSize),
                          ),
                          Text(
                            '07:32 AM',
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

            //TODO: PROBLEM: WHEN PRICE COLUMN AND TOTAL COLUMN GOES TO 5 DIGITS AND 2 DECIMAL PLACES (I.E. 10,000.00)
            // THE ENTIRE TABLE WILL WARP. NEED TO FIND A WAY TO MAKE IT MORE DYNAMIC
            // NEED TO SOLVE ITEM NAME TOO. USED ELIPSIS FOR NOW
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
                  ...selectedItems
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
                                child: Text(
                                    (e.quantity * e.price).toStringAsFixed(1)),
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
                          color: Colors.grey[200], fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal,
                    child: Text(
                      'PHP ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.grey[200], fontWeight: FontWeight.bold),
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
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'SEARCH ITEM',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'PAYMENT',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
    );
  }
}
