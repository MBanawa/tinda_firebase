import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tinda/home_page.dart';
import 'package:tinda/authentication/authentication.dart';
import 'package:tinda/providers/category_provider.dart';
import 'package:tinda/providers/google_sign_in.dart';
import 'package:tinda/providers/phonesize_provider.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tinda/services/cache/initializers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeCache();
  runApp(Phoenix(child: Tinda()));
}

class Tinda extends StatefulWidget {
  @override
  _TindaState createState() => _TindaState();
}

class _TindaState extends State<Tinda> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => PhoneSize()),
            ChangeNotifierProvider(create: (ctx) => CategoryProvider()),
            ChangeNotifierProvider(create: (ctx) => GoogleSignInProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.teal,
              scaffoldBackgroundColor: Colors.grey.shade200,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.yellow.shade900,
              ),
            ),
            home: snapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return HomePage();
                      }
                      return AuthenticScreen();
                    },
                  ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.teal,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/welcome.png'),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      child: Text(
                        'Please Wait...',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
