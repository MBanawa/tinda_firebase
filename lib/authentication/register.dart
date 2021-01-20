import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinda/home_page.dart';

import 'package:tinda/widgets/customTextField.dart';
import 'package:tinda/widgets/errorDialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

//-----------------
  Future<void> register() async {
    _passwordtextEditingController.text == _cPasswordtextEditingController.text
        ? _emailtextEditingController.text.isNotEmpty &&
                _passwordtextEditingController.text.isNotEmpty &&
                _cPasswordtextEditingController.text.isNotEmpty &&
                _nametextEditingController.text.isNotEmpty
            ? _registerUser()
            : showErrorDialog(
                context,
                'Please complete the registration form:' +
                    '${_nametextEditingController.text.isEmpty ? "\n- Name Field is Empty" : ""}' +
                    '${_emailtextEditingController.text.isEmpty ? "\n- Email Address is Empty" : ""}' +
                    '${_passwordtextEditingController.text.isEmpty ? "\n- Password is Empty" : ""}')
        : showErrorDialog(context, 'Passwords do not match!');
  }
//-----------------

  void _registerUser() async {
    User firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailtextEditingController.text.trim(),
      password: _passwordtextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      showErrorDialog(
        context,
        error.message.toString(),
      );
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser);
    }
  }

//-----------------
  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
      'uid': fUser.uid,
      'email': fUser.email,
      'name': _nametextEditingController.text.trim(),
    });
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }
//-----------------

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        height: _screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                  child: Image.asset(
                    'assets/images/register.png',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nametextEditingController,
                    data: Icons.person,
                    hintText: 'Enter Name',
                    isObscure: false,
                  ),
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
                  CustomTextField(
                    controller: _cPasswordtextEditingController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObscure: true,
                  ),
                ],
              ),
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
                  register();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.9,
              color: Colors.teal,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
