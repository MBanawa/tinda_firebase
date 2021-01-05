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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
              child: BarcodeWidget(
                data: 'Animal Ka',
                barcode: Barcode.qrCode(),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
