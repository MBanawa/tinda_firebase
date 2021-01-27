import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  _scanDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            content: RaisedButton(
              onPressed: () {
                dialog2(context);
              },
            ),
          );
        });
  }

  dialog2(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            actions: [],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scanDialog(context);
        },
      ),
      appBar: AppBar(
        title: Text('Cashier Screen'),
      ),
    );
  }
}
