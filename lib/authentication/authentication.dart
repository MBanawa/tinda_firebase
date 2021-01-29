import 'package:flutter/material.dart';

import 'package:tinda/authentication/login.dart';
import 'package:tinda/authentication/register.dart';
import 'package:tinda/screens/test_screen.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            color: Colors.teal,
          ),
          title: Text(
            'Tinda',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.login,
                ),
                text: 'Sign In',
              ),
              Tab(
                icon: Icon(
                  Icons.account_box,
                ),
                text: 'Sign up',
              ),
            ],
            indicatorColor: Colors.yellow.shade900,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          color: Colors.teal,
          child: TabBarView(children: [
            TestLogin(),
            // Login(),
            Register(),
          ]),
        ),
      ),
    );
  }
}
