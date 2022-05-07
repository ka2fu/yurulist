import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/preference_data.dart';

class RoutineDetailViewModel extends ChangeNotifier {
  late final TodoRepository _repository;

  RoutineDetailViewModel(
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
    _todo.title = title.trim();
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

  // Future getTotalDoneScore() async {
  //   /// 一回totalDoneScoreを取得
  //   // late int totalScore;
  //   await Preference.getIntValue(Todo.findState('tds')).then((value) {
  //   });
  // }

  Future done() async {
    setState(Todo.findState('done'));
    _repository.update(todo);

    /// 一回totalDoneScoreを取得
    late int totalScore;
    await Preference.getIntValue(Todo.findState('tds')).then((value) {
      totalScore = value;
    });

    /// 新しく保存
    Preference.setTodalDoneScore(
        Todo.findState('tds'), totalScore + todo.score);
  }

  Future save() async {
    _todo.createdAt = DateTime.now();

    late int earliestTodayTime;
    await Preference.getIntValue(Todo.findState('et')).then((value) {
      earliestTodayTime = value;
    });

    if (earliestTodayTime == 0) {
      /// 一つ目のToDoの保存
      Preference.setIntValue(Todo.findState('et'), _todo.createdAt);
      Preference.setTimeString(Todo.findState('et-str'), _todo.createdAt);
    }

    _todo.state = Todo.findState('routine');
    return await _repository.insert(_todo);
  }

  Future update() async {
    _todo.createdAt = DateTime.now();
    return await _repository.update(todo);
  }

  Future delete() async => await _repository.delete(todo);
}
