import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/data/local_db/db_helper.dart';
import 'package:todo_app/util/todo_tile.dart';

class second_screen extends StatefulWidget {
  static var todolist;

  const second_screen({super.key});

  @override
  State<second_screen> createState() => _home_screenState();
}

class _home_screenState extends State<second_screen> {
  // List in which data is storeda
  int boolean = 1;
  bool isloading = true;
  List todolist = [];
  List<Map<String, dynamic>> alldata = [];
  DbHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DbHelper.instance;
    getTodoData();

    // log("database method called got");
  }

  //getting all todo data
  void getTodoData() async {
    alldata = await dbRef!.getTodo();
    setState(() {
      isloading = false;
    });
  }

  //On check box clicked
  void oncheckbox_changed(int index, bool? newValue) async {
    int newState = newValue! ? 1 : 0;

    //  Instantly update UI
    setState(() {
      alldata[index]["iscomp"] = newState;
    });

    //  Pass the correct database ID instead of index
    await dbRef!.updateTodo(
      check: newState,
      id: alldata[index]["S_no"], // Correct database ID
    );

    // If the update fails, revert the UI
    
      setState(() {
        alldata[index]["iscomp"] = newState == 1 ? 0 : 1;
      });
    
    setState(() {
    
    });
  }

  final TextEditingController _controller = TextEditingController();
  // add todo in database
  void createTodoDb() {
    String todoTitle = _controller.text;

    setState(() {
      dbRef!.addTodo(title: todoTitle, iscompleted: false);
      _controller.clear();
      getTodoData();
    });
    //print("getTododata");
    Navigator.of(context).pop();
  }

  // creating / adding task in the todolist
  void createTask() {
    String task = _controller.text;
    setState(() {
      todolist.add([false, task]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
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
                        onPressed: createTodoDb,
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
    return isloading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
              itemCount: alldata.length,
              itemBuilder:
                  (context, index) => InkWell(
                    onLongPress: () => deleteTask(index),

                    child: todoTile(
                      checkbox_value: alldata[index]["iscomp"] == 1,
                      note: alldata[index]["title"],
                      onChanged:
                          (newValue) => oncheckbox_changed(index, newValue),
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
