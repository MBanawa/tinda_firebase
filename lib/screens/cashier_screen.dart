import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  double _smallFontSize = 8;
  double _medFontSize = 12;
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Inday\'s General Merch',
                      style: TextStyle(
                        fontSize: _smallFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      'Mc Arthur Highway, Balibago',
                      style: TextStyle(
                        fontSize: _smallFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      'Angeles City, Pampanga 2009',
                      style: TextStyle(
                        fontSize: _smallFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                Text('INVOICE',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    )),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'DATE:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      'INVOICE NUM:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      'TOTAL:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '18-Feb-2021',
                      style: TextStyle(
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      '000589',
                      style: TextStyle(
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                    Text(
                      'PHP 500.00',
                      style: TextStyle(
                        fontSize: _medFontSize,
                        color: _largeFontColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
