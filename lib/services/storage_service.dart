import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class StorageService {
  static const _tasksKey = 'noprocrasti_tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_tasksKey);
    if (jsonString == null) {
      return [];
    }

    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, jsonString);
  }
}
