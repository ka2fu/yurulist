import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/list_change_date.dart';

class TodoDetailViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  TodoDetailViewModel(
    this._repository,
    bool isNew,
    Todo todo,
  ) {
    _todo = isNew ? initTodo() : todo;
    _isNew = isNew;
    notifyListeners();
  }

  late Todo _todo;
  Todo get todo => _todo;
  late bool _isNew;
  bool get isNew => _isNew;

  Todo initTodo() {
    return Todo(
      id: const Uuid().v4(),
      title: '',
      score: 1,
      state: '',
      createdAt: null,
    );
  }

  void setTitle(String title) {
    _todo.title = title;
    notifyListeners();
  }

  void setScore(int score) {
    _todo.score = score;
    notifyListeners();
  }

  void setState(String state) {
    _todo.state = state;
    notifyListeners();
  }

  Future save() async {
    // List<Todo> todos = await _repository.loadTodos(Todo.findState('today'));
    _todo.createdAt = DateTime.now();

    late int earliestTodayTime;
    await Preference.getIntValue(Todo.findState('et')).then((value) {
      earliestTodayTime = value;
    });

    if (earliestTodayTime == 0) {
      Preference.setIntValue(Todo.findState('et'), _todo.createdAt);
    }
    // けす
    await Preference.getIntValue(Todo.findState('et'))
        .then((int value) => debugPrint(value.toString()));

    _todo.state = Todo.findState('today');
    return await _repository.insert(_todo);
  }

  Future update() async {
    _todo.createdAt = DateTime.now();
    return await _repository.update(todo);
  }

  Future delete() async => await _repository.delete(todo);
}
