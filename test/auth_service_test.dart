import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noprocrasti/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('registering multiple accounts allows each one to sign in', () async {
    SharedPreferences.setMockInitialValues({});
    final authService = AuthService();

    await authService.registerUser(
      username: 'Alice',
      email: 'alice@example.com',
      password: 'secret123',
    );
    await authService.registerUser(
      username: 'Bob',
      email: 'bob@example.com',
      password: 'anotherpass',
    );

    final alice = await authService.signInWithEmail('alice@example.com', 'secret123');
    final bob = await authService.signInWithEmail('bob@example.com', 'anotherpass');

    expect(alice?.name, 'Alice');
    expect(bob?.name, 'Bob');
  });
}
