import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  final Function onChanged;
  bool isObscure = true;

  CustomTextField(
      {Key key,
      this.controller,
      this.data,
      this.hintText,
      this.isObscure,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Theme.of(context).primaryColor),
        onChanged: onChanged,
        controller: controller,
        obscureText: isObscure,
        cursorColor: Colors.teal,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.teal),
          border: InputBorder.none,
          prefixIcon: data == null
              ? null
              : Icon(
                  data,
                  color: Colors.teal,
                ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
