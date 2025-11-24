import 'package:flutter/material.dart';

class TODOAPP_Functionality extends StatefulWidget {
  const TODOAPP_Functionality({super.key});

  @override
  State<TODOAPP_Functionality> createState() => _TODOAPP_FunctionalityState();
}

class _TODOAPP_FunctionalityState extends State<TODOAPP_Functionality> {
  List<Map<String, dynamic>> tasks = [];
  bool showActiveTask = true;
  late BuildContext _context;  // Store the build context for snackbars

  void _addTask(String task) {
    setState(() {
      tasks.add({
        'id': UniqueKey(),
        'task': task,
        'completed': false,
      });
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text('Task added!')),
      );
      Navigator.pop(_context);
    });
  }

  void _editTask(String newTask, Key taskId) {  // Changed from String to Key
    print('Editing task with id: $taskId');  // Debug print
    print('New task: $newTask');  // Debug print
    final taskIndex = tasks.indexWhere((t) => t['id'] == taskId);
    print('Task index: $taskIndex');  // Debug print
    if (taskIndex != -1) {
      print('Old task: ${tasks[taskIndex]['task']}');
      setState(() {
        tasks[taskIndex]['task'] = newTask;
      });// Debug print

      print('New task set: ${tasks[taskIndex]['task']}');  // Debug print
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text('Task updated!')),
      );
    } else {
      print('Task not found!');  // Debug print
    }
    // Removed Navigator.pop from here; handled in onPressed
  }

  void _showTaskDialogue(int? index, {Map<String, dynamic>? existingTask}) {
    TextEditingController _taskEditingController = TextEditingController();
    if (existingTask != null) {
      _taskEditingController.text = existingTask['task'];
    }
    showDialog(
      context: _context,  // Use stored context
      builder: (context) => AlertDialog(
        title: Text(existingTask == null ? 'Add Task' : 'Edit Task'),
        content: TextField(
          controller: _taskEditingController,
          decoration: InputDecoration(hintText: 'Enter Task'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            onPressed: () {
              String trimmedText = _taskEditingController.text.trim();
              if (trimmedText.isNotEmpty) {
                if (existingTask == null) {
                  _addTask(trimmedText);
                } else {
                  _editTask(trimmedText, existingTask['id']);  // Now passes Key
                  Navigator.pop(context);  // Pop dialog after edit
                }
              } else {
                ScaffoldMessenger.of(_context).showSnackBar(
                  SnackBar(content: Text('Task cannot be empty')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  int get activeCount => tasks.where((task) => !task['completed']).length;
  int get completedCount => tasks.where((task) => task['completed']).length;

  @override
  Widget build(BuildContext context) {
    _context = context;  // Store the build context
    List<Map<String, dynamic>> filteredTasks =
    tasks.where((task) => task['completed'] != showActiveTask).toList();
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTask = true;
                  });
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            activeCount.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTask = false;
                  });
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            completedCount.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Dismissible(
                  key: ValueKey(task['id']),
                  background: Container(
                    color: Colors.green,
                    child: Icon(
                      Icons.check_box,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        final taskIndex = tasks.indexWhere((t) => t['id'] == task['id']);
                        if (taskIndex != -1) {
                          tasks[taskIndex]['completed'] = !tasks[taskIndex]['completed'];
                        }
                      });
                    } else if (direction == DismissDirection.endToStart) {
                      setState(() {
                        tasks.removeWhere((t) => t['id'] == task['id']);
                      });
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        task['task'],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task['completed'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        shape: CircleBorder(),
                        value: task['completed'],
                        onChanged: (value) {
                          setState(() {
                            final taskIndex = tasks.indexWhere((t) => t['id'] == task['id']);
                            if (taskIndex != -1) {
                              tasks[taskIndex]['completed'] = value ?? false;
                            }
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () => _showTaskDialogue(null, existingTask: task),
                      ),
                      onLongPress: () => _showTaskDialogue(null, existingTask: task),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialogue(null),
        child: Icon(Icons.add),
      ),
    );
  }
}