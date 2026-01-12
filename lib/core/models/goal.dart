import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int? dailyTargetMinutes; // Optional target

  @HiveField(3)
  final DateTime startDate;

  Goal({
    String? id,
    required this.title,
    this.dailyTargetMinutes,
    required this.startDate,
  }) : id = id ?? const Uuid().v4();
}
