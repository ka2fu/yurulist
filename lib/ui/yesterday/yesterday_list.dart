import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/ui/yesterday/yesterday_detail.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';
import 'package:yuruli/ui/yesterday/yesterday_list_view_model.dart';
import 'package:yuruli/util/home_utils.dart';

class YesterdayList extends StatelessWidget {
  static int get index => 2;

  const YesterdayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = YesterdayListViewModel(TodoRepository(TodoDatabase()));
    final page = _YesterdayListPage();
    final appBar = HomeAppBar(screenTitle: '未達成のToDo');
    return ChangeNotifierProvider(
        create: (_) => vm,
        child: Scaffold(
          appBar: appBar.builder(context),
          body: page,
        ));
  }
}

class _YesterdayListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<YesterdayListViewModel>(context);

    late int totalDoneScore;
    // debugPrint('isExpired? 1: ${vm.isExpired.toString()}');
    late String earliestTodoTime;

    Future.delayed(
        Duration.zero,
        () async => {
              // debugPrint('isExpired? 2: ${vm.isExpired.toString()}'),
              await Preference.getIntValue(Todo.findState('tds'))
                  .then((value) => {
                        totalDoneScore = value,
                      }),
              await Preference.getStringValue(Todo.findState('et-str'))
                  .then((value) => {
                        earliestTodoTime = value,
                  }),
            }).then((_) => {
          // debugPrint('isExpired? 3: ${vm.isExpired.toString()}'),
          if (vm.isExpired)
            {
              Utils.showTotalDoneScoreDialog(context, totalDoneScore, earliestTodoTime),
              Preference.removeValue(Todo.findState('tds')),
              vm.setExpired(false),
            }
        });

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.todos.isEmpty) {
      return Center(
        child: Text(
          '前回やり残したToDoはないよ',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      );
    }

    return ListView.builder(
        itemCount: vm.todos.length,
        itemBuilder: (BuildContext context, int index) {
          var todo = vm.todos[index];
          return _buildTodoListTile(context, todo);
        });
  }

  Widget _buildTodoListTile(BuildContext context, Todo todo) {
    return Card(
      child: ListTile(
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Container(
          width: 30,
          height: 30,
          child: Center(
            child: Text(
              todo.getScore().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        trailing: Text(
          todo.getCreatedAt(),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
        onTap: () =>
            Navigator.of(context).push<dynamic>(YesterdayDetailPage.route(todo)),
      ),
    );
  }
}
