import 'package:intl/intl.dart';

enum TaskStatus { pending, active, paused, done }

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime createdAt;
  final Duration estimatedDuration;
  final int orderIndex;
  final TaskStatus status;
  final TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.createdAt,
    required this.estimatedDuration,
    required this.orderIndex,
    required this.status,
    required this.priority,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    Duration? estimatedDuration,
    int? orderIndex,
    TaskStatus? status,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      orderIndex: orderIndex ?? this.orderIndex,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  bool get isOverdue => status != TaskStatus.done && dueDate.isBefore(DateTime.now());
  bool get isWaiting => status == TaskStatus.paused;
  bool get isInWaitingPhase => status == TaskStatus.paused;
  String get dueDateLabel => DateFormat.yMMMEd().add_jm().format(dueDate);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'estimatedDuration': estimatedDuration.inMinutes,
      'orderIndex': orderIndex,
      'status': status.name,
      'priority': priority.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDuration: Duration(minutes: json['estimatedDuration'] as int),
      orderIndex: json['orderIndex'] as int,
      status: TaskStatus.values.firstWhere((value) => value.name == json['status'] as String),
      priority: TaskPriority.values.firstWhere((value) => value.name == json['priority'] as String),
    );
  }
}
