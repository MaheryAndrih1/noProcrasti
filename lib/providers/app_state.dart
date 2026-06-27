import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/settings.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../services/storage_service.dart';
import '../services/suggestion_service.dart';
import '../services/task_service.dart';

class AppState extends ChangeNotifier {
  final AuthService authService;
  final TaskService taskService;
  final StorageService storageService;
  final NotificationService notificationService;
  final SuggestionService suggestionService;
  final SettingsService settingsService;

  AppUser? currentUser;
  List<Task> tasks = [];
  List<Task> suggestions = [];
  AppSettings settings = const AppSettings();
  bool isInitializing = true;
  bool busy = false;
  String? authMessage;
  String? overdueNotificationMessage;
  final Set<String> _notifiedOverdueTaskIds = {};
  Timer? _activeTaskTimer;

  String? get _currentUserId => currentUser?.id;

  AppState({
    AuthService? authService,
    TaskService? taskService,
    StorageService? storageService,
    NotificationService? notificationService,
    SuggestionService? suggestionService,
    SettingsService? settingsService,
  })  : authService = authService ?? AuthService(),
        storageService = storageService ?? StorageService(),
        taskService = taskService ?? TaskService(storageService: storageService ?? StorageService()),
        notificationService = notificationService ?? NotificationService(),
        suggestionService = suggestionService ?? SuggestionService(),
        settingsService = settingsService ?? SettingsService();

  Future<void> initialize() async {
    isInitializing = true;
    notifyListeners();

    currentUser = await authService.restoreSession();
    settings = await settingsService.loadSettings();
    tasks = currentUser == null ? [] : await taskService.loadTasks(userId: currentUser!.id);
    suggestions = suggestionService.suggest(tasks);

    isInitializing = false;
    _startActiveTimerIfNeeded();
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    busy = true;
    authMessage = null;
    notifyListeners();

    final signedIn = await authService.signInWithEmail(email, password);
    if (signedIn != null) {
      currentUser = signedIn;
      tasks = await taskService.loadTasks(userId: signedIn.id);
      suggestions = suggestionService.suggest(tasks);
      busy = false;
      notifyListeners();
      return true;
    } else {
      authMessage = 'Invalid credentials. Try signing up or check your email/password.';
    }

    busy = false;
    notifyListeners();
    return false;
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    busy = true;
    authMessage = null;
    notifyListeners();

    final registered = await authService.registerUser(
      username: username,
      email: email,
      password: password,
    );

    busy = false;
    authMessage = registered ? 'Account created. Please log in.' : 'Failed to create account.';
    notifyListeners();
    return registered;
  }

  Future<void> signOut() async {
    await authService.signOut();
    _activeTaskTimer?.cancel();
    currentUser = null;
    tasks = [];
    suggestions = [];
    authMessage = null;
    overdueNotificationMessage = null;
    _notifiedOverdueTaskIds.clear();
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required Duration estimatedDuration,
    required TaskPriority priority,
  }) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      estimatedDuration: estimatedDuration,
      remainingDuration: estimatedDuration,
      orderIndex: tasks.length,
      status: TaskStatus.pending,
      priority: priority,
    );

    tasks = [...tasks, newTask];
    await _saveAndRefresh();
  }

  Future<void> startTask(Task task) async {
    tasks = taskService.updateStatus(tasks, task, TaskStatus.active);
    await _saveAndRefresh();
  }

  Future<void> pauseTask(Task task) async {
    tasks = taskService.updateStatus(tasks, task, TaskStatus.paused);
    await _saveAndRefresh();
  }

  Future<void> completeTask(Task task) async {
    tasks = taskService.updateStatus(tasks, task, TaskStatus.done);
    await _saveAndRefresh();
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    tasks = taskService.reorder(tasks, oldIndex, newIndex);
    await _saveAndRefresh();
  }

  Future<void> deleteTask(Task task) async {
    tasks = taskService.deleteTask(tasks, task);
    await _saveAndRefresh();
  }

  Future<void> _saveAndRefresh() async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    await taskService.saveTasks(tasks, userId: userId);
    if (settings.notificationsEnabled) {
      await notificationService.initialize();
      await notificationService.scheduleOverdueNotifications(tasks);
    }
    suggestions = suggestionService.suggest(tasks);
    if (tasks.where((task) => task.isOverrun).isEmpty) {
      overdueNotificationMessage = null;
      _notifiedOverdueTaskIds.clear();
    }
    _startActiveTimerIfNeeded();
    notifyListeners();
  }

  void _startActiveTimerIfNeeded() {
    _activeTaskTimer?.cancel();
    final activeTask = tasks.where((task) => task.status == TaskStatus.active).isNotEmpty
        ? tasks.firstWhere((task) => task.status == TaskStatus.active)
        : null;

    if (activeTask == null) {
      return;
    }

    _activeTaskTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final latestActive = tasks.where((task) => task.status == TaskStatus.active).isNotEmpty
          ? tasks.firstWhere((task) => task.status == TaskStatus.active)
          : null;

        if (latestActive == null) {
        timer.cancel();
        return;
      }

      if (latestActive.effectiveRemaining <= Duration.zero) {
        if (!_notifiedOverdueTaskIds.contains(latestActive.id)) {
          overdueNotificationMessage = 'Overdue task: ${latestActive.title}';
          _notifiedOverdueTaskIds.add(latestActive.id);
        }
        notifyListeners();
        return;
      }

      notifyListeners();
    });
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    settings = newSettings;
    await settingsService.saveSettings(settings);
    notifyListeners();
  }

  @override
  void dispose() {
    _activeTaskTimer?.cancel();
    super.dispose();
  }
}
