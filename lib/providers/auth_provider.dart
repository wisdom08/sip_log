import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _currentUser = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _currentUser = await _authService.signInWithEmail(email, password);
    notifyListeners();
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    _currentUser = await _authService.signUpWithEmail(
      email,
      password,
      displayName,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
