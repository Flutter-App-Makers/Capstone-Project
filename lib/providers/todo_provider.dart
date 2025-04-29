import 'package:capstone_project/utils/json_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_project/models/todo.dart';
import 'package:hive/hive.dart';

final todoProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]) {
    // Load existing todos from Hive
    final box = Hive.box<Todo>('todos');
    final existingTodos = box.values.toList();
    state = existingTodos;
  }
  static int currId = 0;

  Future<void> addTodo(String content, TodoCategory category) async {
    Todo newTodo = Todo(
      todoId: (currId++).toString(),
      content: content,
      isCompleted: false,
      category: category,
    );
    state = [
      ...state,
      newTodo,
    ];
    Hive.box<Todo>('todos').add(newTodo);
    await exportTodos(state);  // <--- Auto backup
  }

  Future<void> addRecurrentTodo(String content, TodoCategory category) async {
    Todo newTodo = Todo(
        todoId: (currId++).toString(),
        content: content,
        isCompleted: false,
        recurrent: true,
        category: category,
      );
    state = [
      ...state,
      newTodo,
    ];
    Hive.box<Todo>('todos').add(newTodo);
    await exportTodos(state);  // <--- Auto backup
  }

  TodoCategory getCategory(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).category;
  }

  Future<void> completeTodo(int id) async {
    state = [
      for (final todo in state)
        if (todo.todoId == id.toString())
          Todo(
            todoId: todo.todoId,
            content: todo.content,
            isCompleted: true,
            recurrent: todo.recurrent,
            category: todo.category,
          )
        else
          todo
    ];

    final box = Hive.box<Todo>('todos');
    final todoToComplete = box.values.firstWhere(
      (todo) => todo.todoId == id.toString(),
    );

    todoToComplete.isCompleted = true;
    todoToComplete.save(); // 🛡️ Update in Hive to persist completion status

    await exportTodos(state);  // <--- Auto backup
  }

  bool isComplete(int id) {
    return state.firstWhere((todo) => todo.todoId == id.toString()).isCompleted;
  }

  Future<void> deleteTodo(int id) async {
    final box = Hive.box<Todo>('todos');
    final todoToDelete = box.values.firstWhere(
      (todo) => todo.todoId == id.toString(),
    );
    todoToDelete.delete(); // 🛡️ Delete from Hive
    
    // Then remove from in-memory state too
    state = state.where((todo) => todo.todoId != id.toString()).toList();

    await exportTodos(state);  // <--- Auto backup
  }


  Future<void> setTodos(List<Todo> newTodos) async {
    state = newTodos;

    // Set currId safely based on imported todos
    if (newTodos.isNotEmpty) {
      final ids =
          newTodos.map((todo) => int.tryParse(todo.todoId) ?? -1).toList();
      final maxId = ids.isEmpty ? 0 : (ids.reduce((a, b) => a > b ? a : b));
      currId = maxId + 1;
    } else {
      currId = 0;
    }

    await exportTodos(state);  // <--- Auto backup
  }
}
