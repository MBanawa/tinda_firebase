import 'package:flutter/material.dart';

class SuccessAlertDialog extends StatelessWidget {
  final String message;
  const SuccessAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal,
      key: key,
      content: Text(
        message,
        maxLines: 99,
        softWrap: true,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.of(builderContext).pop();
        });
        return SuccessAlertDialog(
          message: message,
        );
      });
}
