import 'package:flutter/material.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/model/repository/todo_repository.dart';

class YesterdayDetailViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  YesterdayDetailViewModel(
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

    /// todoに移す際earliestTodayTimeを更新する可能性がある
    late int earliestTodayTime;
    await Preference.getIntValue(Todo.findState('et')).then((value) {
      earliestTodayTime = value;
    });

    if (earliestTodayTime == 0) {
      // 一つ目のToDoの保存
      Preference.setIntValue(Todo.findState('et'), _todo.createdAt);
      Preference.setTimeString(Todo.findState('et-str'), _todo.createdAt);
    }

    return await _repository.update(todo);
  }
}
