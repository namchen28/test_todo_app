part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoStarted extends TodoEvent {}

class AddTask extends TodoEvent {
  final ToDoModel task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TodoEvent {
  final ToDoModel task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TodoEvent {
  final ToDoModel task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];
}
