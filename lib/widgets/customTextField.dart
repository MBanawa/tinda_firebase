import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final GestureTapCallback onTap;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  final Function onChanged;
  bool isObscure = true;

  CustomTextField(
      {Key key,
      this.onTap,
      this.onSubmitted,
      this.focusNode,
      this.keyboardType,
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
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: TextField(
        onTap: onTap,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        keyboardType: keyboardType,
        autocorrect: false,
        style: TextStyle(color: Colors.teal.shade900),
        onChanged: onChanged,
        controller: controller,
        obscureText: isObscure,
        cursorColor: Colors.teal,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.teal.shade900),
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
