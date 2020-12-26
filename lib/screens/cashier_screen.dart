import 'package:flutter/material.dart';
import 'package:tinda/main.dart';
import 'package:tinda/widgets/itemBuilder/new_item.dart';

class CashierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewItem(
                    barcode: '123456',
                    category: 'Snacks',
                  )));
        },
      ),
      appBar: AppBar(
        title: Text('Cashier Screen'),
      ),
    );
  }
}
