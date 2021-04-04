//TODO: FINISH THIS AND THE REPORTING SCREEN ASAP. WE NEED TO PRESENT IT TO BOSS LLOYD.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  double _smallFontSize = 12;
  double _medFontSize = 16;
  Color _largeFontColor = Colors.grey[700];

  CollectionReference itemcollection =
      FirebaseFirestore.instance.collection('items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner_sharp),
        onPressed: () {},
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
              height: 70,
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
                      height: 80,
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
                    height: 90,
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
                    height: 90,
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
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[900],
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Text(
                              'ITEMS',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            'Cookies N Cream Chocolate Flavor',
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            'Chippy',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            'Marlboro Red',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[900],
                          height: 40,
                          child: Center(
                            child: Text(
                              'QTY',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '2',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '7',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '10',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[900],
                          height: 40,
                          child: Center(
                            child: Text(
                              'PRICE',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '10.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '50.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '5.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.grey[900],
                          height: 40,
                          child: Center(
                            child: Text(
                              'TOTAL',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '20.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '350.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '50.00',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
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
                      'PHP 420.00',
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
                      'PHP 500.00',
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
                      'PHP 80.00',
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
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green;
                        return Colors.teal;
                      })),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
