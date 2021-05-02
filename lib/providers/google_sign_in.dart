import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tinda/widgets/refresh_starter.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      isSigningIn = true;
      final googleauth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).then((_) {
        refreshStarter();
      });
      isSigningIn = false;
    }
  }

  void logout() async {
    FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
  }
}
