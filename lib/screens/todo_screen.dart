import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/bloc/todo_bloc.dart';
import 'package:todo_test/bloc_export.dart';

import 'package:todo_test/database/db_handler.dart';
import 'package:todo_test/local_notification.dart';
import 'package:todo_test/screens/add_update_screen.dart';
import 'package:todo_test/model/todo_model.dart';
import 'package:todo_test/task_card.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late final TodoBloc todoBloc;
  DBhelper? dBhelper;
  late Future<List<ToDoModel>> dataList;

  @override
  void initState() {
    LocalNotification().init();
    super.initState();
    dBhelper = DBhelper();
    loadData();
    todoBloc = TodoBloc();
    todoBloc.add(TodoStarted());
  }

  loadData() async {
    dataList = dBhelper!.getDataList();
  }

  @override
  void dispose() {
    todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: true,
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.status == ToDoStatus.success) {
            loadData();
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          bloc: todoBloc,
          builder: (context, state) {
            if (state.status == ToDoStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == ToDoStatus.error) {
              return const Center(child: Text('An error occurred'));
            } else if (state.allTasks.isEmpty) {
              return const Center(child: Text('No Task Found'));
            } else {
              return ListView.builder(
                itemCount: state.allTasks.length,
                itemBuilder: (context, index) {
                  final task = state.allTasks[index];
                  return Dismissible(
                    key: ValueKey<int>(task.id!),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      margin: const EdgeInsets.all(10),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      todoBloc.add(DeleteTask(task));
                      LocalNotification().showNotification(
                          title: 'Task deleted', body: '', payload: '');
                    },
                    child: InkWell(
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUpdateTask(
                              toDoID: task.id!,
                              toDoTitle: task.title!,
                              toDoDescription: task.description!,
                              dueDate: task.dueDate!,
                              status: task.status,
                              update: true,
                            ),
                          ),
                        );
                      },
                      child: TaskCard(task: task, todoBloc: todoBloc),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdateTask(),
            ),
          ).then((value) {
            todoBloc.add(TodoStarted());
          });
        },
        label: const Text('Add Task'),
      ),
    );
  }
}
