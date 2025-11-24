import 'package:flutter/material.dart';

class TODOAPP_Functionality extends StatefulWidget {
  const TODOAPP_Functionality({super.key});

  @override
  State<TODOAPP_Functionality> createState() => _TODOAPP_FunctionalityState();
}

class _TODOAPP_FunctionalityState extends State<TODOAPP_Functionality> {
  List<Map<String,dynamic>> tasks = [];
  bool showActiveTask = true;

  void _addTask(String task) {
    setState(() {
      tasks.add({'task': task, 'completed': false});
      Navigator.pop(context);
    });
  }

  void _showTaskDialogue(int? index) {
    TextEditingController _taskedittingTEcontroller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context)=>AlertDialog(
            title: Text('Add Task'),
            content: TextField(
              controller: _taskedittingTEcontroller,
              decoration: InputDecoration(hintText: 'Enter Task'),
            ),
            actions: [
              TextButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                onPressed:(){
                  if (_taskedittingTEcontroller.text.trim().isNotEmpty) {
                    _addTask(_taskedittingTEcontroller.text);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }


  int get activeCount => tasks.where((task) => !task['completed']).length;
  int get completedCount => tasks.where((task) => task['completed']).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: Text('Todo App'),
          backgroundColor: Colors.blue),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
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
                          '10',
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
              Card(
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
                          '10',
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
            ],
          ),

          Expanded(
            child: ListView.builder(
              itemCount:tasks.length,
                itemBuilder: (context,index){
                return Card(
                  child: ListTile(
                    title: Text(tasks[index]['task']),
                  ),
                );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>_showTaskDialogue(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
