import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/main.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/ui/yesterday/yesterday_detail_view_model.dart';
import 'package:yuruli/ui/yesterday/yesterday_list.dart';
import 'package:yuruli/util/home_utils.dart';
import 'package:yuruli/util/detail_utils.dart';

class YesterdayDetailPage extends StatelessWidget {
  static Route<dynamic> route(Todo todo) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => YesterdayDetailPage(todo),
    );
  }

  late final Todo _todo;

  YesterdayDetailPage(
    this._todo,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YesterdayDetailViewModel(TodoRepository(TodoDatabase()), _todo),
      child: _YesterdayDetailPage(),
    );
  }
}

class _YesterdayDetailPage extends StatelessWidget {
  void _showUpdateDialog(BuildContext context) {
    var vm = Provider.of<YesterdayDetailViewModel>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('ToDoリストに戻す'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'キャンセル',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  '戻す',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () => _update(context, vm),
              ),
            ],
          );
        });
  }

  void _update(BuildContext context, YesterdayDetailViewModel vm) async {
    Utils.showIndicator(context);
    vm.setState(Todo.findState('today'));
    await vm.update();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: YesterdayList.index));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<YesterdayDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Utils.goToHomeScreen(
              context, HomePage(removeUntilIndex: YesterdayList.index)),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
        title: const Text(
          '未達成のToDoの確認',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 25, left: 25),
          margin: const EdgeInsets.only(top: 40, bottom: 40),
          child: Column(
            children: <Widget>[
              StatusField(title: 'ToDo', content: vm.todo.title),
              const SizedBox(height: 40),
              StatusField(title: 'スコア', content: vm.todo.score.toString()),
              const SizedBox(height: 100),
              _buildUpdateButton(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context, YesterdayDetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ElevatedButton(
        onPressed: () => _showUpdateDialog(context),
        child: const Text(
          '今日のToDoリストに戻す',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          onPrimary: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
