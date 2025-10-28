import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson == null) return null;

    try {
      // Here you would parse the JSON
      // For now, we'll return null to indicate no user is logged in
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<User> signInWithEmail(String email, String password) async {
    // For demo purposes, create a mock user
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: email.split('@')[0],
      createdAt: DateTime.now(),
    );

    await _saveUser(user);
    return user;
  }

  Future<User> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
    );

    await _saveUser(user);
    return user;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.id);
    // In a real app, you would save the full user object as JSON
  }
}
