import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//used in BottomNavigation

class BuildFaIcon extends StatelessWidget {
  BuildFaIcon(this.faicon);

  final IconData faicon;

  @override
  Widget build(BuildContext context) {
    return FaIcon(faicon, size: 30, color: Colors.white);
  }
}
