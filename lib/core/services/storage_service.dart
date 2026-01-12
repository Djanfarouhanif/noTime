import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goal.dart';
import '../models/daily_progress.dart';

final storageServiceProvider = Provider<StorageService>((ref) => throw UnimplementedError());

class StorageService {
  late Box<Goal> _goalsBox;
  late Box<DailyProgress> _progressBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(DailyProgressAdapter());

    _goalsBox = await Hive.openBox<Goal>('goals');
    _progressBox = await Hive.openBox<DailyProgress>('daily_progress');
  }

  Box<Goal> get goalsBox => _goalsBox;
  Box<DailyProgress> get progressBox => _progressBox;
}
