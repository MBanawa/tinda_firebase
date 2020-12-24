import 'package:flutter/material.dart';
import 'package:tinda/main.dart';

class CashierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SplashScreen()));
        },
      ),
      appBar: AppBar(
        title: Text('Cashier Screen'),
      ),
    );
  }
}
