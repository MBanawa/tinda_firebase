import 'package:flutter/material.dart';

import 'package:tinda/home_page.dart';

void main() => runApp(Tinda());

class Tinda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade200,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow.shade900,
        ),
      ),
      home: HomePage(),
    );
  }
}
