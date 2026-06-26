import 'package:flutter_test/flutter_test.dart';
import 'package:noprocrasti/models/task.dart';
import 'package:noprocrasti/services/suggestion_service.dart';

void main() {
  group('SuggestionService', () {
    late SuggestionService service;

    setUp(() {
      service = SuggestionService();
    });

    test('returns paused tasks first when active task exists', () {
      final tasks = [
        Task(
          id: '1',
          title: 'Paused task',
          description: 'A paused task',
          dueDate: DateTime.now().add(const Duration(hours: 1)),
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          estimatedDuration: const Duration(minutes: 30),
          orderIndex: 0,
          status: TaskStatus.paused,
          priority: TaskPriority.medium,
        ),
        Task(
          id: '2',
          title: 'Pending task',
          description: 'A pending task',
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          estimatedDuration: const Duration(minutes: 30),
          orderIndex: 1,
          status: TaskStatus.pending,
          priority: TaskPriority.high,
        ),
        Task(
          id: '3',
          title: 'Active task',
          description: 'Currently active',
          dueDate: DateTime.now().add(const Duration(hours: 3)),
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          estimatedDuration: const Duration(minutes: 45),
          orderIndex: 2,
          status: TaskStatus.active,
          priority: TaskPriority.high,
        ),
      ];

      final suggestions = service.suggest(tasks);

      expect(suggestions.first.id, '1');
      expect(suggestions.length, 1);
    });

    test('orders overdue tasks before higher priority tasks', () {
      final tasks = [
        Task(
          id: '1',
          title: 'Overdue task',
          description: 'Deadline missed',
          dueDate: DateTime.now().subtract(const Duration(minutes: 5)),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          estimatedDuration: const Duration(minutes: 60),
          orderIndex: 0,
          status: TaskStatus.pending,
          priority: TaskPriority.low,
        ),
        Task(
          id: '2',
          title: 'Important task',
          description: 'High priority but not overdue',
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          estimatedDuration: const Duration(minutes: 45),
          orderIndex: 1,
          status: TaskStatus.pending,
          priority: TaskPriority.high,
        ),
      ];

      final suggestions = service.suggest(tasks);

      expect(suggestions.first.id, '1');
      expect(suggestions.last.id, '2');
    });
  });
}
