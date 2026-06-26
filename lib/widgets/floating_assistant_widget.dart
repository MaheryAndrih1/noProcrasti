import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/app_state.dart';

class FloatingAssistantWidget extends StatefulWidget {
  const FloatingAssistantWidget({super.key});

  @override
  State<FloatingAssistantWidget> createState() => _FloatingAssistantWidgetState();
}

class _FloatingAssistantWidgetState extends State<FloatingAssistantWidget> {
  Offset position = const Offset(24, 120);
  bool isStuck = false;
  bool isExpanded = false;

  void _handleDragUpdate(DragUpdateDetails details, Size parentSize) {
    final next = position + details.delta;
    final dx = next.dx.clamp(0.0, parentSize.width - 72.0);
    final dy = next.dy.clamp(0.0, parentSize.height - 72.0);
    setState(() {
      position = Offset(dx, dy);
      isStuck = false;
    });
  }

  void _handleDragEnd(DragEndDetails details, Size parentSize) {
    final threshold = 40.0;
    final leftDist = position.dx;
    final rightDist = parentSize.width - position.dx;
    final topDist = position.dy;
    final bestEdge = [leftDist, rightDist, topDist].reduce(min);

    setState(() {
      if (bestEdge == leftDist) {
        position = Offset(0, position.dy);
        isStuck = true;
      } else if (bestEdge == rightDist) {
        position = Offset(parentSize.width - 72.0, position.dy);
        isStuck = true;
      } else if (bestEdge == topDist) {
        position = Offset(position.dx, 0);
        isStuck = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final activeTask = state.tasks.firstWhere(
      (task) => task.status == TaskStatus.active,
      orElse: () => state.tasks.isNotEmpty ? state.tasks.first : Task(
        id: 'empty',
        title: 'No task',
        description: 'Add a task to start.',
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(hours: 1)),
        estimatedDuration: const Duration(minutes: 30),
        orderIndex: 0,
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      ),
    );

    final widgetShape = isStuck ? BoxShape.rectangle : BoxShape.circle;
    final borderRadius = isStuck ? BorderRadius.circular(24) : null;
    final content = isExpanded
        ? _AssistantDetail(task: activeTask)
        : const Icon(Icons.lightbulb_outline, color: Colors.white);

    if (!isDesktop) {
      return Positioned(
        right: 16,
        bottom: 16,
        child: FloatingActionButton(
          onPressed: () => _showMobilePanel(context, activeTask),
          child: const Icon(Icons.lightbulb_outline),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onPanUpdate: (details) => _handleDragUpdate(details, constraints.biggest),
          onPanEnd: (details) => _handleDragEnd(details, constraints.biggest),
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: isExpanded ? 260 : 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: widgetShape,
              borderRadius: borderRadius,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            padding: const EdgeInsets.all(12),
            child: content,
          ),
        ),
      );
    });
  }

  void _showMobilePanel(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _AssistantDetail(task: task);
      },
    );
  }
}

class _AssistantDetail extends StatelessWidget {
  final Task task;

  const _AssistantDetail({required this.task});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Now', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(task.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(task.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton(
                onPressed: task.status != TaskStatus.active ? () => state.startTask(task) : null,
                child: const Text('Start'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: task.status == TaskStatus.active ? () => state.pauseTask(task) : null,
                child: const Text('Pause'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
