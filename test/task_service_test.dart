import 'package:flutter_test/flutter_test.dart';
import 'package:noprocrasti/models/task.dart';
import 'package:noprocrasti/services/storage_service.dart';
import 'package:noprocrasti/services/task_service.dart';

class _FakeStorageService extends StorageService {
  List<Task> tasks = [];

  @override
  Future<List<Task>> loadTasks({required String userId}) async => tasks;

  @override
  Future<void> saveTasks(List<Task> tasks, {required String userId}) async {
    this.tasks = tasks;
  }
}

void main() {
  group('TaskService', () {
    late TaskService service;
    late _FakeStorageService storage;

    setUp(() {
      storage = _FakeStorageService();
      service = TaskService(storageService: storage as dynamic);
    });

    test('reorder normalizes order index', () {
      final tasks = [
        Task(
          id: '1',
          title: 'One',
          description: '',
          dueDate: DateTime.now().add(const Duration(hours: 1)),
          createdAt: DateTime.now(),
          estimatedDuration: const Duration(minutes: 30),
          remainingDuration: const Duration(minutes: 30),
          orderIndex: 0,
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
        ),
        Task(
          id: '2',
          title: 'Two',
          description: '',
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          createdAt: DateTime.now(),
          estimatedDuration: const Duration(minutes: 30),
          remainingDuration: const Duration(minutes: 30),
          orderIndex: 1,
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
        ),
      ];

      final result = service.reorder(tasks, 0, 1);
      expect(result[0].id, '2');
      expect(result[0].orderIndex, 0);
      expect(result[1].id, '1');
      expect(result[1].orderIndex, 1);
    });

    test('updateStatus pauses previous active task when a new one starts', () {
      final tasks = [
        Task(
          id: '1',
          title: 'First',
          description: '',
          dueDate: DateTime.now().add(const Duration(hours: 1)),
          createdAt: DateTime.now(),
          estimatedDuration: const Duration(minutes: 20),
          remainingDuration: const Duration(minutes: 20),
          orderIndex: 0,
          status: TaskStatus.active,
          priority: TaskPriority.high,
        ),
        Task(
          id: '2',
          title: 'Second',
          description: '',
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          createdAt: DateTime.now(),
          estimatedDuration: const Duration(minutes: 20),
          remainingDuration: const Duration(minutes: 20),
          orderIndex: 1,
          status: TaskStatus.pending,
          priority: TaskPriority.medium,
        ),
      ];

      final result = service.updateStatus(tasks, tasks[1], TaskStatus.active);
      expect(result.first.status, TaskStatus.paused);
      expect(result.last.status, TaskStatus.active);
    });
  });
}
