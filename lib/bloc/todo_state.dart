part of 'todo_bloc.dart';

enum ToDoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<ToDoModel> allTasks;
  final ToDoStatus status;
  const TodoState(
      {this.allTasks = const <ToDoModel>[], this.status = ToDoStatus.initial});

  @override
  List<Object> get props => [allTasks];

  TodoState copyWith({
    ToDoStatus? status,
    List<ToDoModel>? allTasks,
  }) {
    return TodoState(
      allTasks: allTasks ?? this.allTasks,
      status: status ?? this.status,
    );
  }
}
