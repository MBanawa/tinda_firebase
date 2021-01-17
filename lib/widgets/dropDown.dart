import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinda/providers/category_provider.dart';

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

            return Container(
              width: 400,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: snapshot.data.docs.map((DocumentSnapshot document) {
                    return DropdownMenuItem(
                      value: document.id,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          document.data()['categoryname'],
                          style: TextStyle(color: Colors.teal.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  value: _selectedValue,
                  onChanged: (categValue) {
                    setState(() {
                      _selectedValue = categValue;
                    });
                    Provider.of<CategoryProvider>(context, listen: false)
                        .acceptCategory(_selectedValue);
                  },
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Select a Category',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
