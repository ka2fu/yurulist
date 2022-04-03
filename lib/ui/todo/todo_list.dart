import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/ui/todo/todo_detail.dart';
import 'package:yuruli/ui/todo/todo_list_view_model.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';

class TodoList extends StatelessWidget {
  static int get index => 1;

  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = TodoListViewModel(TodoRepository(TodoDatabase()));
    final page = _TodoListPage();
    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).push<dynamic>(HelpPage.route()),
            icon: const FaIcon(FontAwesomeIcons.circleQuestion),
          ),
          title: const Text(
            'today',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.of(context).push<dynamic>(SettingPage.route()),
              icon: const FaIcon(FontAwesomeIcons.gear),
            ),
          ],
        ),
        body: page,
        floatingActionButton: FloatingActionButton(
          onPressed: () => page._goToTodoDetailScreen(context, Todo(), true),
              // Navigator.of(context).push<dynamic>(TodoDetailPage.route(Todo(), true)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoListViewModel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.todos.isEmpty) {
      return Center(
        // child: Text(
        //   'ToDoリストを追加して',
        //   style: TextStyle(color: Theme.of(context).hintColor)
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ToDoリストを追加して',
              style: TextStyle(color: Theme.of(context).hintColor)
            ),
            const Text(
              'default',
            ),
          ],
        ),
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
        onTap: () => _goToTodoDetailScreen(context, todo, false),
      ),
    );
  }

  void _goToTodoDetailScreen(BuildContext context, Todo todo, bool isNew) {
    var route = MaterialPageRoute(
      settings: const RouteSettings(name: 'ui.todo_detail'),
      builder: (BuildContext context) => TodoDetailPage(todo, isNew),
    );
    Navigator.push(context, route);
  }
}
