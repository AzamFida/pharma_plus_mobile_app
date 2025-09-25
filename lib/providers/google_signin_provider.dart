// lib/providers/google_signin_provider.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  void _setSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    _setSigningIn(true);
    try {
      await _initialize();

      // Request scopes like in your original code
      final List<String> scopes = ['email', 'profile'];

      final GoogleSignInAccount? account = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );

      if (account == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in aborted by user')),
        );
        return null;
      }

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(scopes);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: (await account.authentication).idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome, ${userCredential.user?.displayName ?? 'User'} 🎉',
          ),
          backgroundColor: Colors.green,
        ),
      );

      return userCredential.user;
    } on GoogleSignInException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Sign-In Error: ${e.code.name} - ${e.description}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
      return null;
    } finally {
      _setSigningIn(false);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign-out error: $e')));
    }
  }
}
