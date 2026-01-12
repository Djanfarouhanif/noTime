import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/screens/home_screen.dart';
import '../features/goals/screens/add_goal_screen.dart';
import '../features/daily_tracking/screens/daily_checkin_screen.dart';
import 'models/goal.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-goal',
        builder: (context, state) => const AddGoalScreen(),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) {
          final goal = state.extra as Goal; // Pass Goal object
          return DailyCheckinScreen(goal: goal);
        },
      ),
    ],
  );
});
