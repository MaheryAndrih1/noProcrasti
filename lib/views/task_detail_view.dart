import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_state.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final latestTask = state.tasks.firstWhere(
          (item) => item.id == task.id,
          orElse: () => task,
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Task detail')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(latestTask.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(latestTask.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('Due ${latestTask.dueDateLabel}')),
                            Chip(label: Text('Priority ${latestTask.priority.name.toUpperCase()}')),
                            Chip(label: Text(latestTask.status.name.toUpperCase())),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Duration: ${latestTask.estimatedDuration.inMinutes} min', style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('Remaining: ${latestTask.remainingLabel}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: latestTask.status != TaskStatus.active && latestTask.status != TaskStatus.done
                          ? () => state.startTask(latestTask)
                          : null,
                      child: const Text('Start'),
                    ),
                    FilledButton(
                      onPressed: latestTask.status == TaskStatus.active ? () => state.pauseTask(latestTask) : null,
                      child: const Text('Pause'),
                    ),
                    TextButton(
                      onPressed: latestTask.status != TaskStatus.done ? () => state.completeTask(latestTask) : null,
                      child: const Text('Mark done'),
                    ),
                    OutlinedButton(
                      onPressed: () => state.deleteTask(latestTask),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
