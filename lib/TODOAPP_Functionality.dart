import 'package:flutter/material.dart';

class TODOAPP_Functionality extends StatefulWidget {
  const TODOAPP_Functionality({super.key});

  @override
  State<TODOAPP_Functionality> createState() => _TODOAPP_FunctionalityState();
}

class _TODOAPP_FunctionalityState extends State<TODOAPP_Functionality> {
  List<Map<String, dynamic>> tasks = [];
  bool showActiveTask = true;

  void _addTask(String task) {
    setState(() {
      tasks.add({
        'id': UniqueKey(),  // Add unique ID for each task
        'task': task,
        'completed': false
      });
      Navigator.pop(context);
    });
  }

  void _showTaskDialogue(int? index) {
    TextEditingController _taskEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
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
              if (_taskEditingController.text.trim().isNotEmpty) {
                _addTask(_taskEditingController.text);
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
                final task = filteredTasks[index];  // Get the task map
                return Dismissible(
                  key: ValueKey(task['id']),  // Stable key tied to task ID
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
                      // Toggle completion
                      setState(() {
                        final taskIndex = tasks.indexWhere((t) => t['id'] == task['id']);
                        if (taskIndex != -1) {
                          tasks[taskIndex]['completed'] = !tasks[taskIndex]['completed'];
                        }
                      });
                    } else if (direction == DismissDirection.endToStart) {
                      // Delete task
                      setState(() {
                        tasks.removeWhere((t) => t['id'] == task['id']);
                      });
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(task['task']),
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