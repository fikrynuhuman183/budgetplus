import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _autoLoginKey = 'auto_login';

  // Check if the user is already logged in (auto-login)
  Future<bool> autoLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool autoLogin = prefs.getBool(_autoLoginKey) ?? false;
      if (autoLogin) {
        User? user = _auth.currentUser;
        return user != null;
      }
      return false;
    } catch (e) {
      // Handle any errors here if needed
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_autoLoginKey, true); // Enable auto-login

      return result.user != null;
    } catch (e) {
      // Handle any errors here if needed
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_autoLoginKey, false); // Disable auto-login

    return _auth.signOut();
  }
}
