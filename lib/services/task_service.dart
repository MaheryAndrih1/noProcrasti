import '../models/task.dart';
import 'storage_service.dart';

class TaskService {
  final StorageService storageService;

  TaskService({required this.storageService});

  Future<List<Task>> loadTasks({required String userId}) => storageService.loadTasks(userId: userId);

  Future<void> saveTasks(List<Task> tasks, {required String userId}) {
    final normalized = _normalizeOrder(tasks);
    return storageService.saveTasks(normalized, userId: userId);
  }

  List<Task> updateStatus(List<Task> tasks, Task task, TaskStatus status) {
    return tasks.map((item) {
      if (item.id != task.id) {
        if (status == TaskStatus.active && item.status == TaskStatus.active) {
          return item.copyWith(
            status: TaskStatus.paused,
            remainingDuration: item.effectiveRemaining,
            lastStartedAt: null,
          );
        }
        return item;
      }

      switch (status) {
        case TaskStatus.active:
          return item.copyWith(
            status: TaskStatus.active,
            lastStartedAt: DateTime.now(),
          );
        case TaskStatus.paused:
          return item.copyWith(
            status: TaskStatus.paused,
            remainingDuration: item.effectiveRemaining,
            lastStartedAt: null,
          );
        case TaskStatus.done:
          return item.copyWith(
            status: TaskStatus.done,
            remainingDuration: Duration.zero,
            lastStartedAt: null,
          );
        default:
          return item.copyWith(status: status, lastStartedAt: null);
      }
    }).toList();
  }

  List<Task> reorder(List<Task> tasks, int oldIndex, int newIndex) {
    final items = [...tasks];
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    return _normalizeOrder(items);
  }

  List<Task> deleteTask(List<Task> tasks, Task task) {
    return tasks.where((item) => item.id != task.id).toList();
  }

  List<Task> _normalizeOrder(List<Task> tasks) {
    return tasks
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(orderIndex: entry.key))
        .toList();
  }
}
