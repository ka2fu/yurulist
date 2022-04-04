import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/ui/yesterday/yesterday_detail.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';
import 'package:yuruli/ui/yesterday/yesterday_list_view_model.dart';

class YesterdayList extends StatelessWidget {
  static int get index => 2;

  const YesterdayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = YesterdayListViewModel(TodoRepository(TodoDatabase()));
    final page = _YesterdayListPage();
    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () =>
                Navigator.of(context).push<dynamic>(HelpPage.route()),
            icon: const FaIcon(FontAwesomeIcons.circleQuestion),
          ),
          title: const Text(
            'yesterday',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () =>
                  Navigator.of(context).push<dynamic>(SettingPage.route()),
              icon: const FaIcon(FontAwesomeIcons.gear),
            ),
          ],
        ),
        body: page,
      )
    );
  }
}

class _YesterdayListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<YesterdayListViewModel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.todos.isEmpty) {
      return Center(
        child: Text(
          '昨日やり残したToDoはないよ',
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
        ),
        onTap: () =>
            Navigator.of(context).push<dynamic>(YesterdayDetailPage.route()),
      ),
    );
  }
}
