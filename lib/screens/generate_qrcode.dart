import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class GenerateQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
              data: 'Animal Ka',
              barcode: Barcode.qrCode(),
              color: Colors.black,
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter QR Code Name here',
                    prefixIcon: Icon(
                      Icons.qr_code,
                      color: Colors.teal.shade800,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: 60,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  color: Colors.yellow.shade900,
                  child: Text(
                    'Generate QR Now',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
