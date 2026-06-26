import '../models/task.dart';
import 'storage_service.dart';

class TaskService {
  final StorageService storageService;

  TaskService({required this.storageService});

  Future<List<Task>> loadTasks() => storageService.loadTasks();

  Future<void> saveTasks(List<Task> tasks) {
    final normalized = _normalizeOrder(tasks);
    return storageService.saveTasks(normalized);
  }

  List<Task> updateStatus(List<Task> tasks, Task task, TaskStatus status) {
    return tasks.map((item) {
      if (item.id != task.id) {
        if (status == TaskStatus.active && item.status == TaskStatus.active) {
          return item.copyWith(status: TaskStatus.paused);
        }
        return item;
      }
      return item.copyWith(status: status);
    }).toList();
  }

  List<Task> reorder(List<Task> tasks, int oldIndex, int newIndex) {
    final items = [...tasks];
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    return _normalizeOrder(items);
  }

  List<Task> _normalizeOrder(List<Task> tasks) {
    return tasks
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(orderIndex: entry.key))
        .toList();
  }
}
