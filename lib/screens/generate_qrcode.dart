import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class GenerateQr extends StatefulWidget {
  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  var _qrController = TextEditingController();
  String _qrCode;
  FocusNode _qrFocus = FocusNode();

  void _qrGenerator() {
    FocusScope.of(context).unfocus();
    setState(() {
      _qrCode = _qrController.text.trim();
    });
  }

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
            _qrCode == null
                ? Container(
                    child: Icon(
                      Icons.qr_code,
                      size: 200,
                      color: Colors.teal.shade900,
                    ),
                  )
                : BarcodeWidget(
                    height: 200,
                    width: 200,
                    data: _qrCode,
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
                  focusNode: _qrFocus,
                  controller: _qrController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Type your desired QR Code Name here',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
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
                    // Navigator.pop(context);
                    _qrGenerator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
