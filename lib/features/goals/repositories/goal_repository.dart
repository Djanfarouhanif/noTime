import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/goal.dart';
import '../../../core/models/daily_progress.dart';
import '../../../core/services/storage_service.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return GoalRepository(storage);
});

class GoalRepository {
  final StorageService _storage;

  GoalRepository(this._storage);

  // --- Goals ---
  List<Goal> getGoals() {
    return _storage.goalsBox.values.toList();
  }

  Future<void> addGoal(Goal goal) async {
    await _storage.goalsBox.put(goal.id, goal);
  }

  Future<void> deleteGoal(String id) async {
    await _storage.goalsBox.delete(id);
    // Also delete associated progress
    final progressToDelete = _storage.progressBox.values
        .where((p) => p.goalId == id)
        .map((p) => p.key)
        .toList();
    await _storage.progressBox.deleteAll(progressToDelete);
  }

  // --- Daily Progress ---
  List<DailyProgress> getProgressForGoal(String goalId) {
    return _storage.progressBox.values
        .where((p) => p.goalId == goalId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
  }

  DailyProgress? getTodayProgress(String goalId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      return _storage.progressBox.values.firstWhere(
        (p) => p.goalId == goalId &&
               p.date.year == today.year &&
               p.date.month == today.month &&
               p.date.day == today.day
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDailyProgress(DailyProgress progress) async {
     // Check if exists to update, or add new
     // in Hive, if we use the same key it updates.
     // But here 'id' is our key.
     await _storage.progressBox.put(progress.id, progress);
  }

  // --- Logic ---
  bool canValidateToday(String goalId) {
    return getTodayProgress(goalId) == null; // Logic: can validate if no entry for today
    // Or if we allow edits, we return true always?
    // PRD says: "1 validation max / jour / objectif" but also "Modifiable a posteriori".
    // So we can validate if it doesn't exist, OR update if it does.
    // Ideally we return the existing one to edit.
  }
}
