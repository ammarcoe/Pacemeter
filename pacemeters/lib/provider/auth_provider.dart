import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  AuthProvider() {
    checkSign();
  }

  Future<void> checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_SignedIn") ?? false;
    notifyListeners(); // Notify listeners after updating the value
  }

  // Method to update isSignedIn and save it in SharedPreferences
  Future<void> updateSignIn(bool value) async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = value;
    s.setBool("is_SignedIn", _isSignedIn);
    notifyListeners();
  }
}
