import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final dataKey = GlobalKey();
  bool _isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _loginUser() async {
    FocusScope.of(context).unfocus();
    Scrollable.ensureVisible(dataKey.currentContext);
    setState(() {
      _isLoading = true;
    });
    try {
      await Future.delayed(Duration(milliseconds: 1700), () async {
        await _auth.signInWithEmailAndPassword(
          email: _emailtextEditingController.text.trim(),
          password: _passwordtextEditingController.text.trim(),
        );
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext builderContext) {
              Future.delayed(Duration(milliseconds: 800), () {
                Navigator.of(builderContext).pop();
              });
              return AlertDialog(
                backgroundColor: Colors.teal,
                content: Text(
                  'Authentication Successful!',
                  style: TextStyle(color: Colors.white),
                ),
              );
            });
      });
    } catch (error) {
      print('ERROR MESSAGE: $error');
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('blocked')) {
        errorMessage = error.message.toString;
      } else if (error.toString().contains(
          'There is no user record corresponding to this identifier.')) {
        errorMessage = 'The email address you entered could not be found';
      } else if (error.toString().contains('password is invalid')) {
        errorMessage = 'The password you entered is invalid.';
      }
      showErrorDialog(context, errorMessage);

      setState(() {
        _isLoading = false;
      });
    }
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
            _isLoading == true
                ? Container(
                    alignment: Alignment.center,
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.teal[600]),
                      backgroundColor: Colors.white,
                    ),
                  )
                : Container(),
            Padding(
              key: dataKey,
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
                            : showErrorDialog(
                                context,
                                'Please enter a valid email and password',
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
