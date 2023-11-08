import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_test/database/db_handler.dart';
import 'package:todo_test/model/todo_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final dbHelper = DBhelper();
  TodoBloc() : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onAddTask(AddTask event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ToDoStatus.loading));
    try {
      await dbHelper.insert(event.task);
      List<ToDoModel> tasks = await dbHelper.getDataList();
      emit(state.copyWith(allTasks: tasks, status: ToDoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ToDoStatus.error));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ToDoStatus.loading));
    try {
      await dbHelper.update(event.task);
      List<ToDoModel> tasks = await dbHelper.getDataList();
      emit(state.copyWith(allTasks: tasks, status: ToDoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ToDoStatus.error));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ToDoStatus.loading));
    try {
      await dbHelper.delete(event.task.id!);
      List<ToDoModel> tasks = await dbHelper.getDataList();
      emit(state.copyWith(allTasks: tasks, status: ToDoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ToDoStatus.error));
    }
  }

  Future<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) async {
    try {
      List<ToDoModel> tasks = await dbHelper.getDataList();
      emit(state.copyWith(allTasks: tasks, status: ToDoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ToDoStatus.error));
    }
  }
}
