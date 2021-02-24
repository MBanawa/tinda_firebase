import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  double _smallFontSize = 12;
  double _medFontSize = 16;
  Color _largeFontColor = Colors.grey[700];
  // _scanDialog(context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           content: RaisedButton(
  //             onPressed: () {
  //               dialog2(context);
  //             },
  //           ),
  //         );
  //       });
  // }

  // dialog2(context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           actions: [
  //             RaisedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

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
                            'TOTAL:',
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
                            'PHP 750.00',
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
                            'Cookies N Cream',
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
                            'Chippy',
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
                            'PHP 10.00',
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
                            'PHP 15.00',
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
                            'PHP 20.00',
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
                            'PHP 105.00',
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
                    padding: const EdgeInsets.all(4),
                    color: Colors.teal,
                    width: 100,
                    child: Text('TOTAL           PHP 125'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
