import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';

class TodoListViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  TodoListViewModel(this._repository) {
    loadTodos();
    checkExpireTime();
  }

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadTodos() async {
    _startLoading();
    _todos = await _repository.loadTodos(Todo.setState('today'));
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

  void checkExpireTime() {
    DateTime _homeBuildTime = DateTime.now();
    var formatter = DateFormat('yyyyMMddHHmm', 'ja-JP');
    int _homeBuildTimeInt = int.parse(formatter.format(_homeBuildTime));

    // けす
    debugPrint('home screen build time: $_homeBuildTimeInt');
  }
}
