import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Icon icon;
  final Color colour;
  final double elevation;
  final Function onPressed;

  RoundIconButton({this.icon, this.colour, this.elevation, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.grey.shade900,
      child: icon,
      onPressed: onPressed,
      elevation: elevation,
      constraints: BoxConstraints.tightFor(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.height / 12,
      ),
      shape: CircleBorder(),
      fillColor: colour,
    );
  }
}
