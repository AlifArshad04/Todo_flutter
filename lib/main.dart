import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/taskProvider.dart';

import 'add_task_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final TaskProvider _taskProvider = TaskProvider();
  // List<Task> tasks = _taskProvider;


  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onTaskAdded: (task) {
            setState(() {
              _taskProvider.addTask(task);
            });
          },
        );
      },
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _taskProvider.getTaskCount(),
        itemBuilder: (BuildContext context, int index) {
          final Task task= _taskProvider.getTask(index);

          if (_selectedIndex == 1 && task.isComplete) {
            return Container();
          } else if (_selectedIndex == 2 && !task.isComplete){
            return Container();
          }
          return Card(
            shadowColor: Colors.blueAccent,
            elevation: 2.0,
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle (
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(task.deadline)),
              leading: Checkbox(
                value: task.isComplete,
                onChanged: (bool? value) {
                  setState(() {
                    _taskProvider.toggleTaskComplete(task.id);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            label: "All",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_off),
            label: "Incomplete",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            label: "Completed",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
