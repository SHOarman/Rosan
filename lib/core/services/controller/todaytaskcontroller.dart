import 'package:get/get.dart';

class TaskItem {
  final String title;
  final String priority; // 'High', 'Medium', 'Low'
  final String category; // 'Health', 'Work', 'Learning', 'Personal', 'Mindfulness'
  final bool showDailyToggle;
  final RxBool isCompleted;
  final RxBool isDaily;

  TaskItem({
    required this.title,
    required this.priority,
    required this.category,
    this.showDailyToggle = false,
    bool isCompleted = false,
    bool isDaily = false,
  })  : isCompleted = isCompleted.obs,
        isDaily = isDaily.obs;
}

class Todaytaskcontroller extends GetxController {
  final RxList<TaskItem> tasks = <TaskItem>[
    TaskItem(
      title: 'Morning workout (30 min)',
      priority: 'High',
      category: 'Health',
      showDailyToggle: true,
      isDaily: true,
      isCompleted: true,
    ),
    TaskItem(
      title: 'Review project proposal',
      priority: 'High',
      category: 'Work',
      showDailyToggle: true,
      isDaily: false,
      isCompleted: false,
    ),
    TaskItem(
      title: 'Read for 20 minutes',
      priority: 'Medium',
      category: 'Learning',
      showDailyToggle: false,
      isDaily: false,
      isCompleted: false,
    ),
    TaskItem(
      title: 'Call mom',
      priority: 'Medium',
      category: 'Personal',
      showDailyToggle: false,
      isDaily: false,
      isCompleted: false,
    ),
    TaskItem(
      title: 'Drink 8 glasses of water',
      priority: 'Low',
      category: 'Health',
      showDailyToggle: false,
      isDaily: false,
      isCompleted: false,
    ),
    TaskItem(
      title: 'Meditate (10 min)',
      priority: 'Low',
      category: 'Mindfulness',
      showDailyToggle: false,
      isDaily: false,
      isCompleted: false,
    ),
  ].obs;

  int get doneCount => tasks.where((task) => task.isCompleted.value).length;

  double get progressPercentage => tasks.isEmpty ? 0.0 : doneCount / tasks.length;

  void toggleTask(TaskItem task) {
    task.isCompleted.value = !task.isCompleted.value;
    tasks.refresh();
  }

  void toggleDaily(TaskItem task) {
    task.isDaily.value = !task.isDaily.value;
    tasks.refresh();
  }

  void addTask(String title, String priority, String category, bool showDailyToggle) {
    tasks.add(
      TaskItem(
        title: title,
        priority: priority,
        category: category,
        showDailyToggle: showDailyToggle,
        isCompleted: false,
        isDaily: false,
      ),
    );
  }

  void deleteTask(TaskItem task) {
    tasks.remove(task);
  }
}