import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tinda/screens/myQrCode_screen.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyQrCodeScreen()));
                    },
                    child: Text(
                      'MY QR Codes',
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
