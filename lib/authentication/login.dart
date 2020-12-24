import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/home_page.dart';

import 'package:tinda/widgets/customTextField.dart';
import 'package:tinda/widgets/errorDialog.dart';
import 'package:tinda/widgets/loadingDialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: _screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: 'Enter Email Address',
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: 'Enter Password',
                    isObscure: true,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.yellow.shade900,
                      onPressed: () {
                        _emailtextEditingController.text.isNotEmpty &&
                                _passwordtextEditingController.text.isNotEmpty
                            ? loginUser()
                            : showDialog(
                                context: context,
                                builder: (c) {
                                  return ErrorAlertDialog(
                                    message:
                                        'Please enter your email and password',
                                  );
                                },
                              );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 65.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.9,
                    color: Colors.teal.shade200,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            FlatButton.icon(
              onPressed: () {},
              // => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AdminSignInPage()),
              // ),
              icon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              label: Text(
                'Forgot Password?',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, Please wait...',
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailtextEditingController.text.trim(),
      password: _passwordtextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => HomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUSer) async {
    FirebaseFirestore.instance.collection("users").doc(fUSer.uid).get();
  }
}
