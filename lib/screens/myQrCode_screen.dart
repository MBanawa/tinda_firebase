import 'package:flutter/material.dart';

class MyQrCodeScreen extends StatefulWidget {
  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Qr Codes'),
      ),
    );
  }
}
