import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user; // the raw Firebase user (uid, email, etc.)
  String? _name; // pulled from Firestore
  String? _role; // pulled from Firestore
  bool _isInitializing = true; // true until we know the starting login state
  bool _isLoading = false; // true while a login/signup request is in flight
  String? _errorMessage;

  User? get user => _user;
  String? get name => _name;
  String? get role => _role;
  bool get isLoggedIn => _user != null;
  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // This line replaces your old tryAutoLogin() completely.
    // Firebase checks on its own whether a session is already saved on
    // this device, and fires this listener with the result automatically.
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _name = null;
      _role = null;
    }
    _isInitializing = false; // we now know the real login state
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      _name = doc.data()?['name'] as String?;
      _role = doc.data()?['role'] as String?;
    }
  }

  /// Creates a new Firebase user, then saves their profile (name, role)
  /// to Firestore under the same UID. Returns true on success.
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email.trim(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _name = name;
      _role = role;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Signs an existing user in. Role is NOT needed here — Firebase only
  /// checks email + password. Role is read back automatically via
  /// authStateChanges() -> _loadUserData() above.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapError(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    // authStateChanges() fires automatically after this, clearing _user.
  }

  // Firebase throws specific error "codes" — we translate them into
  // messages a real user can understand instead of showing raw codes.
  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
