import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/ui/routine/routine_detail.dart';
import 'package:yuruli/ui/routine/routine_list_view_model.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';
import 'package:yuruli/util/home_utils.dart';
import 'package:yuruli/util/detail_utils.dart';

class RoutineList extends StatelessWidget {
  static int get index => 3;

  const RoutineList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = RoutineListViewModel(TodoRepository(TodoDatabase()));
    final page = _RoutineListPage();
    final appBar = HomeAppBar(screenTitle: '習慣リスト');
    late int limit;

    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Scaffold(
        appBar: appBar.builder(context),
        body: page,
        floatingActionButton: FloatingActionButton(
          onPressed: () async => {
            await Preference.getIntValue(Setting.findState('limit'))
                .then((value) {
              limit = value;
            }),
            if (vm.todos.length < limit)
              {
                page._goToDetailScreen(context, Todo(), true),
              }
            else
              {
                Utils.showCustomLimitDialog(context, limit),
              }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _RoutineListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RoutineListViewModel>(context);

    late int totalDoneScore;
    late String earliestTodoTime;

    Future.delayed(
        Duration.zero,
        () async => {
          // debugPrint('in routein list page'),
              await Preference.getIntValue(Todo.findState('tds'))
                  .then((value) => {
                        totalDoneScore = value,
                      }),
              await Preference.getStringValue(Todo.findState('et-str'))
                  .then((value) => {
                              debugPrint('in routein list page'),
                        earliestTodoTime = value,
                      }),
            }).then((_) => {
          if (vm.isExpired)
            {
                        debugPrint('in routein list page **** expired ****'),
              Utils.showTotalDoneScoreDialog(
                  context, totalDoneScore, earliestTodoTime),
              Preference.removeValue(Todo.findState('tds')),
              vm.setExpired(false),
            }
        });

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.todos.isEmpty) {
      return Center(
        child: Text('習慣リストを追加してください。',
            style: TextStyle(color: Theme.of(context).hintColor)),
      );
    }

    return ListView.builder(
      itemCount: vm.todos.length,
      itemBuilder: (BuildContext context, int index) {
        var todo = vm.todos[index];
        return _buildTodoListTile(context, todo);
      },
    );
  }

  Widget _buildTodoListTile(BuildContext context, Todo todo) {
    return Card(
      child: ListTile(
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          todo.getCreatedAt(),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        onTap: () => _goToDetailScreen(context, todo, false),
      ),
    );
  }

  void _goToDetailScreen(BuildContext context, Todo todo, bool isNew) {
    var route = MaterialPageRoute(
      settings: const RouteSettings(name: 'ui.routine_detail'),
      builder: (BuildContext context) => RoutineDetailPage(todo, isNew),
    );
    Navigator.push(context, route);
  }
}
