import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_test/bloc/todo_bloc.dart';
import 'package:todo_test/database/db_handler.dart';
import 'package:todo_test/local_notification.dart';
import 'package:todo_test/screens/todo_screen.dart';
import 'package:todo_test/model/todo_model.dart';

class AddUpdateTask extends StatefulWidget {
  int? toDoID;
  String? toDoTitle;
  String? toDoDescription;
  String? dueDate;
  bool? update;
  bool? status;

  AddUpdateTask({
    super.key,
    this.toDoID,
    this.toDoTitle,
    this.toDoDescription,
    this.dueDate,
    this.update,
    this.status,
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBhelper? dBhelper;
  late Future<List<ToDoModel>> dataList;
  late TodoBloc todoBloc;

  final _fromKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dBhelper = DBhelper();
    todoBloc = BlocProvider.of<TodoBloc>(context);
    loadData();
    if (widget.dueDate != null) {
      DateFormat format = DateFormat("EEEE, dd/MM/yyyy").add_jm();
      _selectedDueDate = format.parse(widget.dueDate!);
      titleController.text = widget.toDoTitle ?? '';
      descController.text = widget.toDoDescription ?? '';
    }
  }

  loadData() async {
    dataList = dBhelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDueDate = DateTime.now();
    String formattedDueDate =
        DateFormat('EEEE, dd/MM/yyyy').add_jm().format(_selectedDueDate);

    String appTitle;
    if (widget.update == true) {
      appTitle = 'Update Task';
    } else {
      appTitle = "Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Task Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Title";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    maxLines: 10,
                    minLines: 6,
                    controller: descController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Task Description'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Description";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => _showDueDatePicker(context),
                child: Text(
                  "Due Date: ${DateFormat("EEEE , dd/MM/yyyy").add_jm().format(_selectedDueDate).toString()}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: CupertinoColors.activeOrange,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        {
                          if (_fromKey.currentState!.validate()) {
                            if (widget.update == true) {
                              todoBloc.add(UpdateTask(
                                ToDoModel(
                                  id: widget.toDoID,
                                  title: titleController.text,
                                  description: descController.text,
                                  dueDate: formattedDueDate.toString(),
                                  status: widget.status,
                                ),
                              ));
                              LocalNotification().showNotification(
                                  title: 'Task updated',
                                  body: titleController.text,
                                  payload: widget.status.toString());
                            } else {
                              todoBloc.add(AddTask(
                                ToDoModel(
                                  title: titleController.text,
                                  description: descController.text,
                                  dueDate: formattedDueDate.toString(),
                                  status: false,
                                ),
                              ));
                              LocalNotification().showNotification(
                                  title: 'Task added',
                                  body: titleController.text,
                                  payload: widget.status.toString());
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ToDoScreen(),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 60,
                        width: 100,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: CupertinoColors.activeOrange,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 60,
                        width: 100,
                        child: const Text('Clear',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDueDatePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDueDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }
}
