import 'package:flutter/material.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/model/repository/todo_repository.dart';

class DoneDetailViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  DoneDetailViewModel(
    this._repository,
    Todo todo,
  ) {
    _todo = todo;
  }

  late Todo _todo;
  Todo get todo => _todo;

  void setState(String state) {
    _todo.state = state;
    notifyListeners();
  }

  Future update() async {
    _todo.createdAt = DateTime.now();
    late int totalScore;
    await Preference.getIntValue(Todo.findState('tds')).then((value) {
      totalScore = value;
    });
    Preference.setTodalDoneScore(
        Todo.findState('tds'), totalScore - todo.score);
    return await _repository.update(todo);
  }
}
