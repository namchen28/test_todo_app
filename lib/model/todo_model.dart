class ToDoModel {
  final int? id;
  final String? title;
  final String? description;
  final String? dueDate;
  bool? status;

  ToDoModel(
      {this.id,
      this.title,
      this.description,
      this.dueDate,
      this.status = false});

  ToDoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        dueDate = res['duedate'],
        status = res['status'] == 0 ? false : true;

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "duedate": dueDate,
      "status": status,
    };
  }

  ToDoModel copyWith({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    bool? status,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}
