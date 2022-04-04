import 'package:flutter/material.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/ui/done/done_list_view_model.dart';

class YesterdayListViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  YesterdayListViewModel(this._repository) {
    loadTodos();
  }

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadTodos() async {
    _startLoading();
    _todos = await _repository.loadTodos(Todo.setState('yesterday'));
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
