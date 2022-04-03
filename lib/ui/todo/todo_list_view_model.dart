import 'package:flutter/material.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';

class TodoListViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  TodoListViewModel(this._repository) {
    loadTodos();
  }

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadTodos() async {
    _startLoading();
    //　けす
    debugPrint('todo mae');
    _todos = await _repository.loadTodos(Todo.setState('today'));
    // けす
    debugPrint('todo ato');
    _finishLoading();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
