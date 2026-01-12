import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../goals/providers/goal_provider.dart';
import '../../stats/widgets/progress_chart.dart';
import '../../goals/repositories/goal_repository.dart';
import '../../../core/models/goal.dart';
import '../../../core/models/daily_progress.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // We need to fetch progress for all goals to show the unified chart
  Map<String, List<DailyProgress>> _allHistories = {};

  @override
  void initState() {
    super.initState();
    // In a real app we'd use a dedicated provider to watch all progress
    // For MVP, we load it once or on goal updates.
    // However, goalsProvider only gives us the list of Goals.
    // We can hook into the build to refresh or just do it in initState
    // But since data might change, better to do it in build via a Future/Stream or just read valid data.

    // Let's defer loading to 'didChangeDependencies' or a simple method called in build if low cost.
    // Safe bet: Fetch in build safely (not async gap) or use a FutureProvider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
     _loadAllProgress();
    });
  }

  void _loadAllProgress() {
    final goals = ref.read(goalsProvider);
    final repo = ref.read(goalRepositoryProvider);
    final Map<String, List<DailyProgress>> temp = {};

    for (var goal in goals) {
      temp[goal.title] = repo.getProgressForGoal(goal.id);
    }

    if (mounted) {
      setState(() {
        _allHistories = temp;
      });
    }
  }

  // Reload when goals change
  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Simple check: if goals changed in provider, this widget rebuilds.
    // But we need to trigger re-fetch of histories.
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);

    // Dirty hack to ensure chart updates when returning from check-in
    // ideally we move this state to a Provider.
    ref.listen(goalsProvider, (previous, next) {
      _loadAllProgress();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'My Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
        ],
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {}, // No-op
          ),
        ),
      ),
      body: SafeArea(
        child: goals.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No goals yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.push('/add-goal'),
                      child: const Text('Create Goal'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // UNIFIED CHART SECTION
                      Text(
                        'Weekly Overview',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: ProgressChart(allHistories: _allHistories),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Your Goals',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // GOAL LIST
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: goals.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          return _GoalCard(goal: goal);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-goal'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/check-in', extra: goal),
      child: Container(
        height: 140, // Reduced height since chart is above
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B4EFF).withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_run,
                  color: Color(0xFFFF6B6B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      goal.title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1E1E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.dailyTargetMinutes != null
                        ? 'Target: ${goal.dailyTargetMinutes}m'
                        : 'No Daily Target',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
