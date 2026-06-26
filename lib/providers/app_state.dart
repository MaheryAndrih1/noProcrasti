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
    tasks = await taskService.loadTasks();
    suggestions = suggestionService.suggest(tasks);

    isInitializing = false;
    notifyListeners();
  }

  Future<void> signIn() async {
    busy = true;
    notifyListeners();

    currentUser = await authService.signInWithGoogle();
    if (currentUser != null) {
      tasks = await taskService.loadTasks();
      suggestions = suggestionService.suggest(tasks);
    }

    busy = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    currentUser = null;
    tasks = [];
    suggestions = [];
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

  Future<void> _saveAndRefresh() async {
    await taskService.saveTasks(tasks);
    if (settings.notificationsEnabled) {
      await notificationService.initialize();
      await notificationService.scheduleOverdueNotifications(tasks);
    }
    suggestions = suggestionService.suggest(tasks);
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    settings = newSettings;
    await settingsService.saveSettings(settings);
    notifyListeners();
  }
}
