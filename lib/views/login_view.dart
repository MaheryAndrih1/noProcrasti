import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('noProcrasti', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text(
                  'Your personal focus assistant.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Consumer<AppState>(
                  builder: (context, state, child) {
                    return ElevatedButton.icon(
                      onPressed: state.busy ? null : () => state.signIn(),
                      icon: const Icon(Icons.login),
                      label: Text(state.busy ? 'Connecting...' : 'Continue with Google'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
