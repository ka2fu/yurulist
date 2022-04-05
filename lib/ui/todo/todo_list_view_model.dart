import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/list_change_date.dart';
import 'package:yuruli/util/home_utils.dart';

class TodoListViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  TodoListViewModel(this._repository) {
    checkExpireTime().then((_) {
      loadTodos();
    });
  }

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadTodos() async {
    _startLoading();
    _todos = await _repository.loadTodos(Todo.findState('today'));
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

  Future getTodos(String state) async {
    var todoList = await _repository.loadTodos(Todo.findState(state));
    return todoList;
  }

  Future setAllTodos() async {
    List<String> states = [
      Todo.findState('done'),
      Todo.findState('yesterday'),
      Todo.findState('today'),
    ];

    var todosMap = Map<String, dynamic>();

    for (var state in states) {
      var todoList = await getTodos(state);
      todosMap[state] = [];

      debugPrint('-----------------------');
      debugPrint('*** $state ***');

      for (var todo in todoList) {
        debugPrint('$state > ${todo.title}');

        todosMap[state].add(todo);
      }
    }

    return todosMap;
  }

  Future checkExpireTime() async {
    _startLoading();
    late int earliestTodayTime;
    await Preference.getIntValue(Todo.findState('et'))
        .then((value) => {earliestTodayTime = value});
    late int earliestYesterdayTime;
    await Preference.getIntValue(Todo.findState('ey'))
        .then((value) => {earliestYesterdayTime = value});

    debugPrint('earliest today time: $earliestTodayTime');
    debugPrint('earliest yesterday time: $earliestYesterdayTime');

    var todosMap = await setAllTodos();

    /// home画面build時の時間
    DateTime buildTime = DateTime.now();
    var formatter = DateFormat(Utils.expireTimeFormat, 'ja-JP');
    int buildTimeInt = int.parse(formatter.format(buildTime));

    // けす
    debugPrint('home screen build time: $buildTimeInt');

    /// earliestTimeが0なら何もしない
    if (earliestTodayTime > Utils.todayExpireDiff) {
      if (buildTimeInt - earliestTodayTime >= 1) {
        todosMap.forEach((state, todoList) {
          todoList.forEach((todo) {
            if (state == Todo.findState('today')) {
              setState(Todo.findState('yesterday'), todo);
              _repository.update(todo);
            } else {
              _repository.delete(todo);
            }
          });
        });

        /// earliestYesterdayTimeは置き換えてearliestTodayTimeは削除
        Preference.setIntValue(Todo.findState('ey'), buildTime);
        Preference.removeValue(Todo.findState('et'));

        debugPrint('move today to yesteday');
      }
    } else if (earliestYesterdayTime > 0) {
      if (buildTimeInt - earliestYesterdayTime >= Utils.yesterdayExpireDiff) {
        todosMap[Todo.findState('yesterday')].forEach((todo) {
          _repository.delete(todo);
        });

        /// earliestYesterdayTimeを削除
        Preference.removeValue(Todo.findState('ey'));

        debugPrint('remove yesterday');
      }
    }

    _finishLoading();
  }
}
