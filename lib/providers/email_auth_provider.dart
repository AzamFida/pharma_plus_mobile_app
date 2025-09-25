// email_auth_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Sign up with email and password
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Save user data to Firestore
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
          'role': 'user', // Default role
        });
      }

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      _setLoading(false);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? "Something went wrong during signup");
      return null;
    } catch (e) {
      _setLoading(false);
      _setError("An unexpected error occurred");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Force token refresh
      await userCredential.user!.getIdToken(true);

      final uid = userCredential.user!.uid;

      // Check if user is admin (skip email verification for admins)
      final adminDoc = await _firestore.collection('admins').doc(uid).get();

      if (adminDoc.exists) {
        _setLoading(false);
        return userCredential.user;
      }

      // For regular users, require email verification
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        _setLoading(false);
        _setError("Please verify your email before logging in!");
        return null;
      }

      // Check if user document exists, create if not
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await _firestore.collection('users').doc(uid).set({
          'email': userCredential.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': userCredential.user!.emailVerified,
          'role': 'user',
        });
      }

      _setLoading(false);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? "Something went wrong during signin");
      return null;
    } catch (e) {
      _setLoading(false);
      _setError("An unexpected error occurred");
      return null;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually if needed
  void clearErrorMessage() {
    _clearError();
  }

  @override
  void dispose() {
    _clearError();
    super.dispose();
  }
}
