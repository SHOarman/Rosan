import 'package:get/get.dart';

class GoalItem {
  final String title;
  final String deadline;
  final String iconType; // 'rocket', 'run', 'book', 'money', 'default'
  final RxDouble progress;

  GoalItem({
    required this.title,
    required this.deadline,
    required this.iconType,
    double progress = 0.0,
  }) : progress = progress.obs;
}

class MygoallController extends GetxController {
  final RxList<GoalItem> goals = <GoalItem>[
    GoalItem(
      title: 'Launch Side Project',
      deadline: 'Aug 2026',
      iconType: 'rocket',
      progress: 0.65,
    ),
    GoalItem(
      title: 'Run 5K',
      deadline: 'Sep 2026',
      iconType: 'run',
      progress: 0.40,
    ),
    GoalItem(
      title: 'Read 24 Books',
      deadline: 'Dec 2026',
      iconType: 'book',
      progress: 0.29,
    ),
    GoalItem(
      title: 'Save \$5,000',
      deadline: 'Dec 2026',
      iconType: 'money',
      progress: 0.55,
    ),
  ].obs;

  double get overallProgress {
    if (goals.isEmpty) return 0.0;
    double sum = goals.fold(0.0, (previous, goal) => previous + goal.progress.value);
    return sum / goals.length;
  }

  int get activeGoalsCount => goals.length;

  void incrementProgress(GoalItem goal) {
    if (goal.progress.value < 1.0) {
      goal.progress.value = (goal.progress.value + 0.10).clamp(0.0, 1.0);
      goals.refresh();
    }
  }

  void addGoal(String title, String deadline) {
    // Generate a random icon type from our types for fun and variety
    final iconTypes = ['rocket', 'run', 'book', 'money'];
    final iconType = iconTypes[goals.length % iconTypes.length];
    
    goals.add(
      GoalItem(
        title: title,
        deadline: deadline,
        iconType: iconType,
        progress: 0.0,
      ),
    );
  }

  void deleteGoal(GoalItem goal) {
    goals.remove(goal);
  }
}