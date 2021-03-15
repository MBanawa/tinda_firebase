import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal,
      key: key,
      title: Text(
        'Alert!',
        style: TextStyle(
          color: Colors.orange,
        ),
      ),
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
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          
          child: Center(
            child: Text(
              'Return',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          style: ButtonStyle(
                                
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green;
                                  return Colors.yellow.shade900;
                                })),
        ),
      ],
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => ErrorAlertDialog(
      message: message,
    ),
  );
}
