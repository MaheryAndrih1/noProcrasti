import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const _userKey = 'noprocrasti_user';
  static const _credentialsKey = 'noprocrasti_credentials';

  Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);
    if (json == null) return null;

    final map = jsonDecode(json) as Map<String, dynamic>;
    return AppUser.fromJson(map);
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final credentialsJson = prefs.getString(_credentialsKey);
    if (credentialsJson == null) return null;

    final credentials = jsonDecode(credentialsJson) as Map<String, dynamic>;
    if (credentials['email'] == email && credentials['password'] == password) {
      final user = AppUser(
        id: credentials['id'] as String,
        name: credentials['name'] as String,
        email: email,
        avatarUrl: null,
      );
      await _saveUser(user);
      return user;
    }

    return null;
  }

  Future<bool> registerUser({required String username, required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final credentials = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': username,
      'email': email,
      'password': password,
    };

    await prefs.setString(_credentialsKey, jsonEncode(credentials));
    return true;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
