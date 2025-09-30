// lib/providers/auth_state_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStateProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthStateProvider() {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    });

    // Also check immediately
    _currentUser = FirebaseAuth.instance.currentUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setUserLoggedIn(User user) async {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  bool get isLoggedIn => _currentUser != null;
}
