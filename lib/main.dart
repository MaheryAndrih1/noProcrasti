import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'views/dashboard_view.dart';
import 'views/login_view.dart';
import 'views/preferences_view.dart';
import 'views/signup_view.dart';
import 'views/task_form_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const NoProcrastiApp());
}

class NoProcrastiApp extends StatelessWidget {
  const NoProcrastiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: Consumer<AppState>(
        builder: (context, state, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'noProcrasti',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            themeMode: state.settings.themeMode,
            home: const RootScreen(),
            routes: {
              LoginView.routeName: (_) => const LoginView(),
              SignupView.routeName: (_) => const SignupView(),
              DashboardView.routeName: (_) => const DashboardView(),
              TaskFormView.routeName: (_) => const TaskFormView(),
              PreferencesView.routeName: (_) => const PreferencesView(),
            },
          );
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        if (state.currentUser == null) {
          return const LoginView();
        }

        return const DashboardView();
      },
    );
  }
}
