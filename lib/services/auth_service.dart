import 'dart:convert';
import 'dart:io' show Platform;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthService {
  static const _userKey = 'noprocrasti_user';
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);
    if (json == null) {
      return null;
    }

    final map = jsonDecode(json) as Map<String, dynamic>;
    return AppUser.fromJson(map);
  }

  Future<AppUser?> signInWithGoogle() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      final fallback = AppUser(
        id: 'local-user',
        name: 'Local User',
        email: 'local@noProcrasti.dev',
        avatarUrl: null,
      );
      await _saveUser(fallback);
      return fallback;
    }

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return null;
      }

      final user = AppUser(
        id: account.id,
        name: account.displayName ?? account.email,
        email: account.email,
        avatarUrl: account.photoUrl,
      );

      await _saveUser(user);
      return user;
    } catch (error) {
      print('Google sign-in failed, falling back to local user: $error');
      final fallback = AppUser(
        id: 'local-user',
        name: 'Local User',
        email: 'local@noProcrasti.dev',
        avatarUrl: null,
      );
      await _saveUser(fallback);
      return fallback;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> _saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
