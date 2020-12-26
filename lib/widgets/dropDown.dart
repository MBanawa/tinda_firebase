import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef OnChangeCallback = void Function(dynamic value);

class FirebaseDropDown extends StatefulWidget {
  final OnChangeCallback onChanged;

  FirebaseDropDown({this.onChanged});
  @override
  _FirebaseDropDownState createState() => _FirebaseDropDownState();
}

class _FirebaseDropDownState extends State<FirebaseDropDown> {
  var _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            return DropdownButton(
              items: snapshot.data.docs.map((DocumentSnapshot document) {
                return DropdownMenuItem(
                  value: document.data()['categoryname'],
                  child: Text(document.data()['categoryname']),
                );
              }).toList(),
              value: _selectedValue,
              onChanged: (categValue) {
                setState(() {
                  _selectedValue = categValue;
                });
              },
              hint: Text('Select a Category'),
            );
          }),
    );
  }
}
