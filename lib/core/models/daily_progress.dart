import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'daily_progress.g.dart';

@HiveType(typeId: 1)
class DailyProgress extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String goalId;

  @HiveField(2)
  final DateTime date; // Should be normalized to midnight

  @HiveField(3)
  final int declaredMinutes;

  @HiveField(4)
  final bool validated;

  DailyProgress({
    String? id,
    required this.goalId,
    required this.date,
    required this.declaredMinutes,
    this.validated = false,
  }) : id = id ?? const Uuid().v4();
}
