import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinda/widgets/customTextField.dart';

class TestLogin extends StatefulWidget {
  @override
  _TestLoginState createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _loginUser() async {
    try {
      await Future.delayed(Duration(milliseconds: 1600), () async {
        await _auth.signInWithEmailAndPassword(
          email: _emailtextEditingController.text.trim(),
          password: _passwordtextEditingController.text.trim(),
        );
      });
    } catch (error) {
      print('ERROR MESSAGE: $error');
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('blocked')) {
        errorMessage = '${error.message}';
      } else if (error.toString().contains(
          'There is no user record corresponding to this identifier.')) {
        errorMessage = 'The email address you entered could not be found';
      } else if (error.toString().contains('password is invalid')) {
        errorMessage = 'The password you entered is invalid.';
      }
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 200),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          _loginUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
