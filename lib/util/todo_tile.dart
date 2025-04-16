import 'package:flutter/material.dart';
import 'package:todo_app/pages/home_screen.dart';

// ignore: camel_case_types
class todoTile extends StatelessWidget {
  final bool checkbox_value;
  final String note;
  Function(bool?)? onChanged;

  todoTile({
    super.key,
    required this.checkbox_value,
    required this.note,
    required this.onChanged,
  });

  

  void deleteTask(){
   home_screen.todolist;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.green[400],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: checkbox_value,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
        
              // note
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  note,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    decoration:
                        checkbox_value
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
