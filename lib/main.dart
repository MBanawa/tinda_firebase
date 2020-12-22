import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinda/authentication/authentication.dart';

import 'package:tinda/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Tinda());
}

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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 3), () async {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user != null) {
          Route route = MaterialPageRoute(builder: (_) => HomePage());
          Navigator.pushReplacement(context, route);
        } else {
          Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.lightBlue,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/welcome.png'),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Your personal Tindahan manager',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
