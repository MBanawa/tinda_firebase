import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final String hintText;

  SearchFieldWidget({
    @required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 1),
                blurRadius: 3.0,
                spreadRadius: 0.5),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: TextField(
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            hintText: hintText,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.teal.shade800,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
