import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/util/home_utils.dart';

class RoutineList extends StatelessWidget {
  static int get index => 3;

  const RoutineList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = RoutineListViewModel(TodoRepository(TodoDatabase()));
    final appBar = HomeAppBar(screenTitle: '習慣リスト');
    return Scaffold(
      appBar: appBar.builder(context),
      body: const Center(
        child: Text('routine'),
      ),
    );
  }
}
