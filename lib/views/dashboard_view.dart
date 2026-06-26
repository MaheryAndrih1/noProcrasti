import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_state.dart';
import 'preferences_view.dart';
import 'task_detail_view.dart';
import 'task_form_view.dart';

class DashboardView extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('noProcrasti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, PreferencesView.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, TaskFormView.routeName),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final tasks = state.tasks;
          final suggestions = state.suggestions;
          final remainingTasks = tasks.where((task) => task.status != TaskStatus.done).toList();
          final doneTasks = tasks.where((task) => task.status == TaskStatus.done).toList();
          final Task? activeTask = remainingTasks.where((task) => task.status == TaskStatus.active).isNotEmpty
              ? remainingTasks.firstWhere((task) => task.status == TaskStatus.active)
              : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your tasks',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(context, TaskFormView.routeName),
                      icon: const Icon(Icons.add),
                      label: const Text('Add task'),
                    ),
                  ],
                ),
              ),
              if (state.overdueNotificationMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.overdueNotificationMessage!,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (activeTask != null) _ActiveTaskCard(task: activeTask),
          if (suggestions.isNotEmpty) _SuggestionSection(suggestions: suggestions),
          if (doneTasks.isNotEmpty) _CompletedSection(doneTasks: doneTasks),
              Expanded(
                child: remainingTasks.isEmpty
                    ? _EmptyTaskState(onAdd: () => Navigator.pushNamed(context, TaskFormView.routeName))
                    : Stack(
                        children: [
                          ReorderableListView.builder(
                            itemCount: remainingTasks.length,
                            onReorder: (oldIndex, newIndex) => state.reorderTasks(oldIndex, newIndex > oldIndex ? newIndex - 1 : newIndex),
                            itemBuilder: (context, index) {
                              final task = remainingTasks[index];
                              return _TaskTile(key: ValueKey(task.id), task: task);
                            },
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyTaskState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyTaskState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first task to stay focused. The task list and add task button are the main interface here.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAdd, child: const Text('Add first task')),
          ],
        ),
      ),
    );
  }
}

class _SuggestionSection extends StatelessWidget {
  final List<Task> suggestions;

  const _SuggestionSection({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task suggestions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Resume paused work first, then choose the next item with the nearest deadline.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Column(
            children: suggestions
                .map((task) => ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      tileColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(task.dueDateLabel),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TaskDetailView(task: task)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CompletedSection extends StatelessWidget {
  final List<Task> doneTasks;

  const _CompletedSection({required this.doneTasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 2,
        child: ExpansionTile(
          title: Text('Completed tasks', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Text('${doneTasks.length} task${doneTasks.length > 1 ? 's' : ''} finished', style: Theme.of(context).textTheme.bodySmall),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: doneTasks
              .map((task) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Done • ${task.dueDateLabel}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TaskDetailView(task: task)),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _ActiveTaskCard extends StatelessWidget {
  final Task task;

  const _ActiveTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Text(task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(task.description, style: const TextStyle(fontSize: 15, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(task.priority.name.toUpperCase())),
                const SizedBox(width: 8),
                Chip(label: Text('Due ${task.dueDateLabel}')),
              ],
            ),
            const SizedBox(height: 12),
            Text('Remaining: ${task.remainingLabel}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final state = context.read<AppState>();
                    state.pauseTask(task);
                  },
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    final state = context.read<AppState>();
                    state.completeTask(task);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;

  const _TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${task.dueDateLabel} • ${task.priority.name.toUpperCase()} • ${task.status.name.toUpperCase()}'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          final state = context.read<AppState>();
          if (value == 'start') {
            state.startTask(task);
          } else if (value == 'pause') {
            state.pauseTask(task);
          } else if (value == 'done') {
            state.completeTask(task);
          } else if (value == 'delete') {
            state.deleteTask(task);
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 'start',
              enabled: task.status != TaskStatus.done && task.status != TaskStatus.active,
              child: const Text('Start'),
            ),
            PopupMenuItem(
              value: 'pause',
              enabled: task.status == TaskStatus.active,
              child: const Text('Pause'),
            ),
            PopupMenuItem(
              value: 'done',
              enabled: task.status != TaskStatus.done,
              child: const Text('Done'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ];
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaskDetailView(task: task)),
      ),
    );
  }
}
