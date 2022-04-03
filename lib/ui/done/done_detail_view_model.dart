import 'package:flutter/material.dart';

import 'package:yuruli/model/entity/todo.dart';
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

  // void setTitle(String title) {
  //   _todo.title = title;
  //   notifyListeners();
  // }

  // void setScore(int score) {
  //   _todo.score = score;
  //   notifyListeners();
  // }

  void setState(String state) {
    _todo.state = state;
    notifyListeners();
  }

  Future update() async {
    _todo.createdAt = DateTime.now();
    return await _repository.update(todo);
  }
}
