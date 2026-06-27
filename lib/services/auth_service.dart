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

    final parsed = jsonDecode(credentialsJson);
    final credentialsList = parsed is List
        ? parsed.whereType<Map<String, dynamic>>().toList()
        : <Map<String, dynamic>>[parsed as Map<String, dynamic>];

    for (final credentials in credentialsList) {
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
    }

    return null;
  }

  Future<bool> registerUser({required String username, required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final credentialsJson = prefs.getString(_credentialsKey);
    final parsed = credentialsJson == null ? null : jsonDecode(credentialsJson);
    final credentialsList = parsed is List
        ? parsed.whereType<Map<String, dynamic>>().toList()
        : (parsed is Map<String, dynamic> ? <Map<String, dynamic>>[parsed] : <Map<String, dynamic>>[]);

    final existingIndex = credentialsList.indexWhere((entry) => entry['email'] == email);
    final credentials = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': username,
      'email': email,
      'password': password,
    };

    if (existingIndex >= 0) {
      credentialsList[existingIndex] = credentials;
    } else {
      credentialsList.add(credentials);
    }

    await prefs.setString(_credentialsKey, jsonEncode(credentialsList));
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
