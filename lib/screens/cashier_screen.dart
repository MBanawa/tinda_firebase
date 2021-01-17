import 'package:flutter/material.dart';

class CashierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => Scratch()));
        },
      ),
      appBar: AppBar(
        title: Text('Cashier Screen'),
      ),
    );
  }
}
