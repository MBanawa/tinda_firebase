import 'package:flutter/material.dart';

import 'package:tinda/widgets/loadingWidget.dart';

class LoadinAlertDialog extends StatelessWidget {
  final String message;
  const LoadinAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(
            height: 10.0,
          ),
          Text(message),
        ],
      ),
    );
  }
}
