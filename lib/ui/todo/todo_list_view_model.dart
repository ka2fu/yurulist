import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/list_change_date.dart';

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

  void setState(String state, Todo todo) {
    todo.state = state;
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future getTods() async {
    _startLoading();
    var t = await _repository.loadTodos(Todo.setState('today'));
    _finishLoading();
    return t;
  }

  Future checkExpireTime() async {
    DateTime _homeBuildTime = DateTime.now();
    var formatter = DateFormat('yyyyMMddHHmm', 'ja-JP');
    int _homeBuildTimeInt = int.parse(formatter.format(_homeBuildTime));

    // けす
    debugPrint('home screen build time: $_homeBuildTimeInt');

    /// get earliest todo's time
    late int earliestTime;
    await Preference.getIntValue(Todo.setState('first')).then((int value) => {
          earliestTime = value,
        });

    // けす
    debugPrint('earliest time: $earliestTime');

    /// 時間が経過したかのチェック
    if (_homeBuildTimeInt - earliestTime >= 1) {
      var t = await getTods();
      debugPrint('todos expired');
      debugPrint(t.toString());
      for (var todo in t) {
        debugPrint(todo.toString());
        setState(Todo.setState('yesterday'), todo);
        _repository.update(todo);
      }
    }
  }
}
