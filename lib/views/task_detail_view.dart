import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_state.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Task detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(task.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Due date: ${task.dueDateLabel}'),
            const SizedBox(height: 8),
            Text('Estimated duration: ${task.estimatedDuration.inMinutes} min'),
            const SizedBox(height: 8),
            Text('Status: ${task.status.name.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Priority: ${task.priority.name.toUpperCase()}'),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: task.status != TaskStatus.active ? () => state.startTask(task) : null,
                  child: const Text('Start'),
                ),
                FilledButton(
                  onPressed: task.status == TaskStatus.active ? () => state.pauseTask(task) : null,
                  child: const Text('Pause'),
                ),
                TextButton(
                  onPressed: task.status != TaskStatus.done ? () => state.completeTask(task) : null,
                  child: const Text('Mark done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
