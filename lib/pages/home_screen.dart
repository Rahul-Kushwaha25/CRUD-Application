import 'package:flutter/material.dart';
import 'package:todo_app/util/todo_tile.dart';

class home_screen extends StatefulWidget {
  static var todolist;

  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  // List in which data is storeda
  List todolist = [
    [false, "Do Task"],
    [false, "Jogging"],
    [false, "Tekken 1v1"],
    [false, "Happy Happy"],
  ];

  //On check box clicked
  void oncheckbox_changed(int index) {
    setState(() {
      todolist[index][0] = !todolist[index][0];
    });
  }

  final TextEditingController _controller = TextEditingController();

  // creating / adding task in the todolist
  void createTask() {
    String task = _controller.text;
    setState(() {
      todolist.add([false, task]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }
  void deleteTask(int index){
    setState(() {
      todolist.removeAt(index);
    });
  }

  // add note floating action button
  void addButtton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[300],
          content: SizedBox(
            height: 150.0,
            width: 200.0,
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Your task...",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: createTask,
                        color: Colors.green[400],
                        child: Text(
                          "Create",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      MaterialButton(
                        onPressed: Navigator.of(context).pop,
                        color: Colors.green[400],
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        centerTitle: true,
        title: Text("Todo"),
        leading: Icon(Icons.add_chart),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: todolist.length,
          itemBuilder:
              (context, index) => InkWell(
                onLongPress: () => deleteTask(index),

                child: todoTile(
                  checkbox_value: todolist[index][0],
                  note: todolist[index][1],
                  onChanged: (p0) => oncheckbox_changed(index),
                ),
              ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          onPressed: () => addButtton(),
          backgroundColor: Colors.green[400],
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
