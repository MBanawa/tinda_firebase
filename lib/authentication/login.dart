import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/models/http_exception.dart';

import 'package:tinda/widgets/customTextField.dart';
import 'package:tinda/widgets/errorDialog.dart';

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
  bool _isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailtextEditingController.text.trim(),
        password: _passwordtextEditingController.text.trim(),
      );
    } catch (error) {
      print(error);
      var errorMessage = 'Authentication failed';
      // if (error.toString().contains('EMAIL_EXISTS')) {
      //   errorMessage = 'This email address is already in use!';
      // } else if (error.toString().contains('INVALID_EMAIL')) {
      //   errorMessage = 'This is not a valid email address';
      // } else if (error.toString().contains('WEAK_PASSWORD')) {
      //   errorMessage = 'The password you enter is too weak';
      // } else
      if (error.toString().contains(
          'There is no user record corresponding to this identifier.')) {
        errorMessage = 'The email you entered could not be found';
      } else if (error.toString().contains('password is invalid')) {
        errorMessage = 'The password you entered is invalid.';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

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
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.yellow.shade900,
                      onPressed: () {
                        _emailtextEditingController.text.isNotEmpty &&
                                _passwordtextEditingController.text.isNotEmpty
                            ? _loginUser()
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
}
