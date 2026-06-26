import '../models/task.dart';

class NotificationService {
  Future<void> initialize() async {
    return;
  }

  Future<void> scheduleOverdueNotifications(List<Task> tasks) async {
    // On desktop, notifications are currently a no-op.
    // This keeps the app runnable without macOS/iOS plugin setup.
    return;
  }
}
