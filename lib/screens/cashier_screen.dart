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
            Container(
              width: double.infinity,
              color: Colors.grey[900],
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
