import 'package:intl/intl.dart';

enum TaskStatus { pending, active, paused, done }

enum TaskPriority { low, medium, high }

class Task {
  static const _unset = Object();

  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime createdAt;
  final Duration estimatedDuration;
  final Duration remainingDuration;
  final DateTime? lastStartedAt;
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
    Duration? remainingDuration,
    this.lastStartedAt,
    required this.orderIndex,
    required this.status,
    required this.priority,
  }) : remainingDuration = remainingDuration ?? estimatedDuration;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    Duration? estimatedDuration,
    Duration? remainingDuration,
    Object? lastStartedAt = _unset,
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
      remainingDuration: remainingDuration ?? this.remainingDuration,
      lastStartedAt: lastStartedAt == _unset ? this.lastStartedAt : lastStartedAt as DateTime?,
      orderIndex: orderIndex ?? this.orderIndex,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  Duration get effectiveRemaining {
    if (status != TaskStatus.active || lastStartedAt == null) {
      return remainingDuration;
    }

    final elapsed = DateTime.now().difference(lastStartedAt!);
    final remaining = remainingDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get remainingLabel {
    final remaining = effectiveRemaining;
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${remaining.inHours.toString().padLeft(2, '0')}:$minutes:$seconds';
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
      'estimatedDuration': estimatedDuration.inSeconds,
      'remainingDuration': remainingDuration.inSeconds,
      'lastStartedAt': lastStartedAt?.toIso8601String(),
      'orderIndex': orderIndex,
      'status': status.name,
      'priority': priority.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final estimatedDurationValue = json['estimatedDuration'];
    final estimatedDurationSeconds = estimatedDurationValue is int
        ? estimatedDurationValue
        : int.tryParse(estimatedDurationValue.toString()) ?? 0;

    final remainingDurationValue = json.containsKey('remainingDuration')
        ? json['remainingDuration']
        : estimatedDurationValue;
    final remainingSeconds = remainingDurationValue is int
        ? remainingDurationValue
        : int.tryParse(remainingDurationValue.toString()) ?? estimatedDurationSeconds;

    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDuration: Duration(seconds: estimatedDurationSeconds),
      remainingDuration: Duration(seconds: remainingSeconds),
      lastStartedAt: json['lastStartedAt'] != null ? DateTime.parse(json['lastStartedAt'] as String) : null,
      orderIndex: json['orderIndex'] as int,
      status: TaskStatus.values.firstWhere((value) => value.name == json['status'] as String),
      priority: TaskPriority.values.firstWhere((value) => value.name == json['priority'] as String),
    );
  }
}
