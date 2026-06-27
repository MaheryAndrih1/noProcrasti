import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:noprocrasti/models/task.dart';
import 'package:noprocrasti/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late StorageService storageService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('noprocrasti_hive_test_');
    Hive.init(tempDir.path);
    storageService = StorageService();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saves and loads tasks from Hive', () async {
    final task = Task(
      id: 'task-1',
      title: 'Database task',
      description: 'Stored in Hive',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now(),
      estimatedDuration: const Duration(minutes: 45),
      remainingDuration: const Duration(minutes: 45),
      orderIndex: 0,
      status: TaskStatus.pending,
      priority: TaskPriority.high,
    );

    await storageService.saveTasks([task], userId: 'user-a');

    final loadedTasks = await storageService.loadTasks(userId: 'user-a');

    expect(loadedTasks, hasLength(1));
    expect(loadedTasks.single.id, task.id);
    expect(loadedTasks.single.title, task.title);
  });

  test('keeps tasks isolated per user', () async {
    final taskA = Task(
      id: 'task-a',
      title: 'Alice task',
      description: 'Private to Alice',
      dueDate: DateTime.now().add(const Duration(hours: 1)),
      createdAt: DateTime.now(),
      estimatedDuration: const Duration(minutes: 30),
      remainingDuration: const Duration(minutes: 30),
      orderIndex: 0,
      status: TaskStatus.pending,
      priority: TaskPriority.medium,
    );
    final taskB = Task(
      id: 'task-b',
      title: 'Bob task',
      description: 'Private to Bob',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now(),
      estimatedDuration: const Duration(minutes: 45),
      remainingDuration: const Duration(minutes: 45),
      orderIndex: 0,
      status: TaskStatus.pending,
      priority: TaskPriority.high,
    );

    await storageService.saveTasks([taskA], userId: 'alice-id');
    await storageService.saveTasks([taskB], userId: 'bob-id');

    final aliceTasks = await storageService.loadTasks(userId: 'alice-id');
    final bobTasks = await storageService.loadTasks(userId: 'bob-id');

    expect(aliceTasks.single.id, taskA.id);
    expect(bobTasks.single.id, taskB.id);
  });
}