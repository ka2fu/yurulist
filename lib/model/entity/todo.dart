import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Todo {
  late String id;
  late String title;
  late int score;
  late String state;
  late var createdAt;

  static Map<String, String> states = {
    'today': 'today',
    'done': 'done',
    'yesterday': 'yesterday',
    'first': 'firstStateTime',
  };

  static setState(String str) {
    try {
      if (!states.containsKey(str)) throw Error;
      return states[str];
    } catch (e) {
      throw 'states key doesnt exist';
    }
  }

  Todo({
    this.id = '',
    this.title = '',
    this.score = 1,
    this.state = '',
    this.createdAt,
  });

  String getCreatedAt() {
    try {
      var formatter = DateFormat('yyyy/MM/dd HH:mm', 'ja-JP');
      return formatter.format(createdAt);
    } catch (e) {
      //　けす
      debugPrint(e.toString());
      return '';
    }
  }

  String getState() {
    return state;
  }

  int getScore() {
    return score;
  }
}
