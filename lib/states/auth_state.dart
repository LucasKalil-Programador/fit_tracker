import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackr/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { uninitialized, authenticating, authenticated, unauthenticated, error }

class AuthState  extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;

  Object? _error;
  Object? get error => _error;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthState() {
    _auth.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser;
      _status = firebaseUser == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      await _googleSignIn.initialize();
      
      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;

      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      _error = e;
      logger.e(e);
      notifyListeners();
    }
    return false;
  }

  Future<bool> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    return true;
  }
}