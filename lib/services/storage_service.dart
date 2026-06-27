import 'package:hive/hive.dart';

import '../models/task.dart';

class StorageService {
  static const _tasksBoxPrefix = 'noprocrasti_tasks_';

  String _tasksBoxNameFor(String userId) => '$_tasksBoxPrefix$userId';

  Future<Box> _openTasksBox(String userId) async {
    final boxName = _tasksBoxNameFor(userId);
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return Hive.openBox(boxName);
  }

  Future<List<Task>> loadTasks({required String userId}) async {
    final box = await _openTasksBox(userId);
    final tasks = box.values
        .whereType<Map>()
        .map((value) => Task.fromJson(Map<String, dynamic>.from(value)))
        .toList();

    tasks.sort((left, right) => left.orderIndex.compareTo(right.orderIndex));
    return tasks;
  }

  Future<void> saveTasks(List<Task> tasks, {required String userId}) async {
    final box = await _openTasksBox(userId);
    await box.clear();
    await box.putAll({for (final task in tasks) task.id: task.toJson()});
  }
}
