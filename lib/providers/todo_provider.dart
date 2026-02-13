import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(String title, String description) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void updateTodo(String id, String title, String description) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].title = title;
      _todos[index].description = description;
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      notifyListeners();
    }
  }

  int getCompletedCount() {
    return _todos.where((todo) => todo.isCompleted).length;
  }

  int getPendingCount() {
    return _todos.where((todo) => !todo.isCompleted).length;
  }
}