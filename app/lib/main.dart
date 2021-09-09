import 'package:flutter/material.dart';
import 'package:products_captor/database/SQFLITEProvider.dart';
import 'package:products_captor/models/Task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color buttonColor = Color(0xFFFF955B);
  Color editorColor = Color(0xFF4044CC);
  TextEditingController inputController = TextEditingController();
  String newTask = "";
  Color primaryColor = Color(0xFF0D0952);
  SQFLITEProvider provider = SQFLITEProvider.provider;
  Color secondaryColor = Color(0xFF212061);

  getAllTasks() async => await provider.getAllTasks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryColor,
        title: Text("My Todo"),
      ),
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getAllTasks(),
              builder: (_, tasks) {
                switch (tasks.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      return tasks.data == Null
                          ? Center(
                              child: Text(
                                "You have no tasks today !",
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: (tasks.data as List).length,
                                itemBuilder: (context, index) {
                                  String task = (tasks.data as List)[index]
                                          ['task']
                                      .toString();
                                  String createdAtDay = DateTime.parse(
                                          (tasks.data as List)[index]
                                              ['created_at'])
                                      .day
                                      .toString();
                                  return Card(
                                    color: secondaryColor,
                                    child: InkWell(
                                      child: Row(children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 12.0),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 16.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            createdAtDay,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              task,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  );
                                },
                              ),
                            );
                    }
                  default:
                    {
                      return Center(
                        child: Text(
                          "You have no tasks today !",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            decoration: BoxDecoration(
              color: editorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type a new task",
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                TextButton.icon(
                  onPressed: () async {
                    String newTask = inputController.text.toString();
                    Task newTaskInstance = Task(
                      id: (await getAllTasks()).length,
                      task: newTask,
                      created_at: DateTime.now(),
                    );
                    await provider.addNewTask(newTaskInstance);
                    setState(() {
                      inputController.text = "";
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Task"),
                  style: TextButton.styleFrom(
                      backgroundColor: buttonColor,
                      primary: Colors.white,
                      shape: StadiumBorder()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
