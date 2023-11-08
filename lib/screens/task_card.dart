import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/bloc/todo_bloc.dart';
import 'package:todo_test/model/todo_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.todoBloc,
  });

  final ToDoModel task;
  final TodoBloc todoBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    task.description!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Checkbox(
                activeColor: Colors.black,
                value: task.status,
                onChanged: (value) {
                  todoBloc.add(
                    UpdateTask(
                      task.copyWith(status: value),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          const Divider(
            thickness: 0.8,
            color: Colors.black,
          ),
          Text(
            task.dueDate!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
