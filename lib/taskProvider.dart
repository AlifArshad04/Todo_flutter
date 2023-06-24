import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  int? id;
  final String title;
  final DateTime deadline;
  bool isComplete;

  Task({
    this.id,
    required this.title,
    required this.deadline,
    this.isComplete = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      deadline: DateTime.parse(json['deadline']),
      isComplete: json['isComplete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'isComplete': isComplete,
    };
  }
}

class TaskProvider {
  int _maxId = 0;
  List<Task> _tasks = [];
  SharedPreferences? _preferences;

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  int getNextId() {
    _maxId++;
    return _maxId;
  }

  int getTaskCount() {
    return _tasks.length;
  }

  Task getTask(int index) {
    return _tasks[index];
  }

  void toggleTaskComplete(int? taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      task.isComplete = !task.isComplete;
      _tasks[taskIndex] = task;
      _saveTasks();
    }
  }

  Future<void> _loadTasks() async {
    final taskIds = _preferences?.getStringList('taskIds') ?? [];
    _maxId = _preferences?.getInt('maxId') ?? 0;

    for (final taskId in taskIds) {
      final taskData = _preferences?.getString(taskId);
      if (taskData != null) {
        final task = Task.fromJson(jsonDecode(taskData));
        _tasks.add(task);
      }
    }
  }

  Future<void> _saveTasks() async {
    final taskIds = _tasks.map((task) => task.id.toString()).toList();
    await _preferences?.setStringList('taskIds', taskIds);
    await _preferences?.setInt('maxId', _maxId);

    final List<String> taskDataList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await _preferences?.setStringList('tasks', taskDataList);
  }

  void addTask(Task task) {
    task.id = getNextId();
    _tasks.add(task);
    _saveTasks();
  }
}
