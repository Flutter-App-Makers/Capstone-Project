import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/models/todo.dart';

final todoProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);
  static int currId = 0;

  void addTodo(String content) {
    state = [
      ...state,
      Todo(
        todoId: currId++,
        content: content,
        completed: false,
      ),
    ];
  }

  void addRecurrentTodo(String content) {
    state = [
      ...state,
      Todo(
        todoId: state.isEmpty ? 0 : state[state.length - 1].todoId + 1,
        content: content,
        completed: false,
        recurrent: true,
      ),
    ];
  }

  void completeTodo(int id) {
    state = [
      for (final todo in state)
        if (todo.todoId == id)
          Todo(
            todoId: todo.todoId,
            content: todo.content,
            completed: true,
            recurrent: todo.recurrent,
          )
        else
          todo
    ];
  }

  bool isComplete(int id) {
    return state.firstWhere((todo) => todo.todoId == id).completed;
  }

  void deleteTodo(int id) {
    state = state.where((todo) => todo.todoId != id).toList();
  }
}
