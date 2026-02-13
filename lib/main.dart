import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'widgets/todo_card.dart';
import 'widgets/add_edit_todo_dialog.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todos'),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Consumer<TodoProvider>(
                builder: (context, todoProvider, _) {
                  return Text(
                    '[0m${todoProvider.getPendingCount()} pending',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) {
          if (todoProvider.todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No todos yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a todo',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return TodoCard(
                todo: todo,
                onToggle: () => todoProvider.toggleTodo(todo.id),
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddEditTodoDialog(
                      todo: todo,
                      onSave: (title, description) {
                        todoProvider.updateTodo(todo.id, title, description);
                      },
                    ),
                  );
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Todo'),
                      content: Text('Are you sure you want to delete this todo?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            todoProvider.deleteTodo(todo.id);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEditTodoDialog(
              onSave: (title, description) {
                context.read<TodoProvider>().addTodo(title, description);
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }
}