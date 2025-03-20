class Todo {
  int todoId;
  String content;
  bool completed;
  bool recurrent;

  Todo({
    required this.todoId,
    required this.content,
    required this.completed,
    this.recurrent = false,
  });
}
