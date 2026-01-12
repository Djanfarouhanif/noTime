import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/goal.dart';
import '../../../core/models/daily_progress.dart';
import '../repositories/goal_repository.dart';

final goalsProvider = NotifierProvider<GoalsNotifier, List<Goal>>(GoalsNotifier.new);

class GoalsNotifier extends Notifier<List<Goal>> {
  late final GoalRepository _repository;

  @override
  List<Goal> build() {
    _repository = ref.watch(goalRepositoryProvider);
    return _repository.getGoals();
  }

  Future<void> saveDailyProgress(String goalId, int minutes) async {
    final progress = DailyProgress(
      goalId: goalId,
      date: DateTime.now(),
      declaredMinutes: minutes,
      validated: true,
    );
    await _repository.saveDailyProgress(progress);
    state = _repository.getGoals(); // Refresh state
  }

  Future<void> addGoal(String title, int? targetMinutes) async {
    final goal = Goal(
      title: title,
      dailyTargetMinutes: targetMinutes,
      startDate: DateTime.now(),
    );
    await _repository.addGoal(goal);
    state = _repository.getGoals(); // Refresh state
  }

  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
    state = _repository.getGoals();
  }
}
