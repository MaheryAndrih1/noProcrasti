import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_state.dart';
import '../widgets/floating_assistant_widget.dart';
import 'preferences_view.dart';
import 'task_detail_view.dart';
import 'task_form_view.dart';

class DashboardView extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final state = WidgetsBinding.instance.lifecycleState;
    _isInBackground = state != AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isInBackground = state != AppLifecycleState.resumed;
    });
  }

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
          final Task? activeTask = tasks.where((task) => task.status == TaskStatus.active).isNotEmpty
              ? tasks.firstWhere((task) => task.status == TaskStatus.active)
              : null;
          final bool showAssistant = state.settings.showFloatingWidget && _isInBackground;

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
              if (activeTask != null) _ActiveTaskCard(task: activeTask),
              if (suggestions.isNotEmpty) _SuggestionSection(suggestions: suggestions),
              Expanded(
                child: tasks.isEmpty
                    ? _EmptyTaskState(onAdd: () => Navigator.pushNamed(context, TaskFormView.routeName))
                    : Stack(
                        children: [
                          ReorderableListView.builder(
                            itemCount: tasks.length,
                            onReorder: (oldIndex, newIndex) => state.reorderTasks(oldIndex, newIndex > oldIndex ? newIndex - 1 : newIndex),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return _TaskTile(key: ValueKey(task.id), task: task);
                            },
                          ),
                          if (showAssistant) const FloatingAssistantWidget(),
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
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You still have these remaining tasks, which do you want to start next?', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Column(
            children: suggestions
                .map((task) => ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.dueDateLabel),
                      trailing: const Icon(Icons.north_east),
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

class _ActiveTaskCard extends StatelessWidget {
  final Task task;

  const _ActiveTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active task', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(task.title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(task.description),
            const SizedBox(height: 8),
            Text('Due: ${task.dueDateLabel}'),
            const SizedBox(height: 12),
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
      title: Text(task.title),
      subtitle: Text('${task.dueDateLabel} • ${task.priority.name.toUpperCase()}'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          final state = context.read<AppState>();
          if (value == 'start') {
            state.startTask(task);
          } else if (value == 'pause') {
            state.pauseTask(task);
          } else if (value == 'done') {
            state.completeTask(task);
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem(value: 'start', child: Text('Start')),
            const PopupMenuItem(value: 'pause', child: Text('Pause')),
            const PopupMenuItem(value: 'done', child: Text('Done')),
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
