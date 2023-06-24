import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/taskProvider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task)? onTaskAdded;

  AddTaskDialog({this.onTaskAdded});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _deadlineController,
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (selectedDate != null) {
                setState(() {
                  _deadlineController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
                });
              }
            },
            decoration: InputDecoration(
              labelText: 'Deadline',
              // hintText: 'Select deadline',
              // border: OutlineInputBorder(),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            print(_deadlineController.text);
            final String title = _titleController.text.trim();
            final DateTime deadline = DateTime.parse(_deadlineController.text);
            final Task newTask = Task(
              title: title,
              deadline: deadline,
            );

            if (widget.onTaskAdded != null) {
              widget.onTaskAdded!(newTask);
            }

            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}