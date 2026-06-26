import '../models/task.dart';

class SuggestionService {
  List<Task> suggest(List<Task> tasks) {
    final activeTask = tasks.where((task) => task.status == TaskStatus.active).isNotEmpty
        ? tasks.firstWhere((task) => task.status == TaskStatus.active)
        : null;

    final candidates = tasks
        .where((task) => task.status == TaskStatus.pending || task.status == TaskStatus.paused)
        .toList();

    candidates.sort((left, right) {
      final leftOverdue = left.isOverdue ? 0 : 1;
      final rightOverdue = right.isOverdue ? 0 : 1;
      if (leftOverdue != rightOverdue) {
        return leftOverdue.compareTo(rightOverdue);
      }
      final priorityOrder = right.priority.index.compareTo(left.priority.index);
      if (priorityOrder != 0) {
        return priorityOrder;
      }
      return left.dueDate.compareTo(right.dueDate);
    });

    if (activeTask == null) {
      return candidates.take(3).toList();
    }

    final waitingTasks = candidates.where((task) => task.status == TaskStatus.paused).toList();
    if (waitingTasks.isNotEmpty) {
      return waitingTasks.take(3).toList();
    }

    final gapTasks = _findGapTasks(activeTask, candidates);
    if (gapTasks.isNotEmpty) {
      return gapTasks.take(3).toList();
    }

    return candidates.take(3).toList();
  }

  List<Task> _findGapTasks(Task activeTask, List<Task> tasks) {
    final threshold = const Duration(minutes: 30);
    final now = DateTime.now();
    final activeEnd = now.add(activeTask.estimatedDuration);

    return tasks.where((task) {
      final gap = task.dueDate.difference(activeEnd).abs();
      return gap <= threshold;
    }).toList();
  }
}
