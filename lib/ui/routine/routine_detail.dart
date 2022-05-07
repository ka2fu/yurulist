import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart'; // flexにしたいとき
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/main.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/ui/routine/routine_detail_view_model.dart';
import 'package:yuruli/ui/routine/routine_list.dart';
import 'package:yuruli/util/home_utils.dart';

class RoutineDetailPage extends StatelessWidget {
  static Route<dynamic> route(Todo todo, bool isNew) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => RoutineDetailPage(todo, isNew),
    );
  }

  late final Todo _todo;
  late final bool _isNew;

  RoutineDetailPage(
    this._todo,
    this._isNew,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          RoutineDetailViewModel(TodoRepository(TodoDatabase()), _isNew, _todo),
      child: _TodoDetailPage(),
    );
  }
}

class _TodoDetailPage extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  void _showSaveOrUpdateDialog(BuildContext context) {
    if (!_globalKey.currentState!.validate()) return;

    var vm = Provider.of<RoutineDetailViewModel>(context, listen: false);
    final bool isNew = vm.isNew;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              isNew ? '保存する?' : '更新する?',
            ),
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
                  isNew ? '保存' : '更新',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                onPressed: () => {
                  isNew ? _save(context, vm) : _update(context, vm),
                },
              ),
            ],
          );
        });
  }

  void _showDeleteDialog(BuildContext context) {
    final vm = Provider.of<RoutineDetailViewModel>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('本当に削除する?'),
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
                  '削除',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                onPressed: () => {
                  _delete(context, vm),
                },
              ),
            ],
          );
        });
  }

  void _changeStatus(RoutineDetailViewModel vm) {
    vm.setTitle(TitleField.title);
    vm.setScore(0);
  }

  void _save(BuildContext context, RoutineDetailViewModel vm) async {
    Utils.showIndicator(context);
    _changeStatus(vm);
    await vm.save();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: RoutineList.index));
  }

  void _update(BuildContext context, RoutineDetailViewModel vm) async {
    Utils.showIndicator(context);
    _changeStatus(vm);
    await vm.update();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: RoutineList.index));
  }

  void _delete(BuildContext context, RoutineDetailViewModel vm) async {
    Utils.showIndicator(context);
    await vm.delete();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: RoutineList.index));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RoutineDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Utils.goToHomeScreen(
              context, HomePage(removeUntilIndex: RoutineList.index)),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
        title: Text(
          vm.isNew ? '新しい習慣を作成' : '習慣を編集',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _globalKey, // ← なんで? ← バリデーション
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: <Widget>[
              TitleField(vm: vm),
              const SizedBox(height: 20),
              // SliderField(vm: vm),
              const SizedBox(height: 60),
              // _buildDoneButton(context, vm),
              _buildSaveButton(context, vm),
              _buildDeleteButton(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, RoutineDetailViewModel vm) {
    return ElevatedButton(
      onPressed: () => _showSaveOrUpdateDialog(context),
      child: Text(
        vm.isNew ? '保存' : '更新',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        onPrimary: Theme.of(context).primaryColorLight,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, RoutineDetailViewModel vm) {
    if (vm.isNew) return const SizedBox(height: 0);

    return ElevatedButton(
      onPressed: () => _showDeleteDialog(context),
      child: const Text(
        '削除',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).errorColor,
        onPrimary: Theme.of(context).errorColor.withBlue(180).withGreen(180),
      ),
    );
  }
}

class TitleField extends StatelessWidget {
  final RoutineDetailViewModel vm;

  static late String _title;
  static String get title => _title;

  TitleField({
    Key? key,
    required this.vm,
  }) : super(
          key: key,
        ) {
    _title = vm.isNew ? '' : vm.todo.title;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '習慣',
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: TextFormField(
            initialValue: vm.isNew ? '' : vm.todo.title,
            maxLength: 30, // 文字数制限
            keyboardType: TextInputType.multiline, // 文字数が多い時改行して複数行表示
            maxLines: null, // 文字数が多い時改行して複数行表示
            validator: (value) => value!.isEmpty ? '習慣を入力して' : null,
            onChanged: (value) => {
              // vm.setTitle(value)
              _title = value,
            },
          ),
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(height: 0),
        ),
      ],
    );
  }
}
