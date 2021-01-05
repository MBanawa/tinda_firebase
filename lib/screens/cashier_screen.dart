import 'package:flutter/material.dart';
import 'package:tinda/screens/generate_qrcode.dart';

class CashierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GenerateQr()));
        },
      ),
      appBar: AppBar(
        title: Text('Cashier Screen'),
      ),
    );
  }
}
