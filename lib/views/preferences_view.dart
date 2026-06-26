import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';
import '../providers/app_state.dart';

class PreferencesView extends StatelessWidget {
  static const routeName = '/preferences';

  const PreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final settings = state.settings;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Enable notifications'),
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  state.updateSettings(settings.copyWith(notificationsEnabled: value));
                },
              ),
              const SizedBox(height: 16),
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) state.updateSettings(settings.copyWith(themeMode: value));
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) state.updateSettings(settings.copyWith(themeMode: value));
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) state.updateSettings(settings.copyWith(themeMode: value));
                },
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: state.isInitializing ? null : () => state.signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}
