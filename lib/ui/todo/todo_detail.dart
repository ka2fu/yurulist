import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart'; // flexにしたいとき
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/main.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/model/repository/todo_repository.dart';
import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/ui/todo/todo_detail_view_model.dart';
import 'package:yuruli/ui/todo/todo_list.dart';
import 'package:yuruli/util/home_utils.dart';

class TodoDetailPage extends StatelessWidget {
  static Route<dynamic> route(Todo todo, bool isNew) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => TodoDetailPage(todo, isNew),
    );
  }

  late final Todo _todo;
  late final bool _isNew;

  TodoDetailPage(
    this._todo,
    this._isNew,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TodoDetailViewModel(TodoRepository(TodoDatabase()), _isNew, _todo),
      child: _TodoDetailPage(),
    );
  }
}

class _TodoDetailPage extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  void _showSaveOrUpdateDialog(BuildContext context) {
    if (!_globalKey.currentState!.validate()) return;

    var vm = Provider.of<TodoDetailViewModel>(context, listen: false);
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
                    color: Theme.of(context).primaryColor,
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
    final vm = Provider.of<TodoDetailViewModel>(context, listen: false);

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

  void _save(BuildContext context, TodoDetailViewModel vm) async {
    Utils.showIndicator(context);
    await vm.save();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  void _update(BuildContext context, TodoDetailViewModel vm) async {
    Utils.showIndicator(context);
    await vm.update();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  void _done(BuildContext context, TodoDetailViewModel vm) async {
    Utils.showIndicator(context);
    await vm.done();
    await vm.getTotalDoneScore(); // debug用
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  void _delete(BuildContext context, TodoDetailViewModel vm) async {
    Utils.showIndicator(context);
    await vm.delete();
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoDetailViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Utils.goToHomeScreen(
              context, HomePage(removeUntilIndex: TodoList.index)),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
        title: Text(
          vm.isNew ? '新規ToDoを作成' : 'ToDoを編集',
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
              const SliderField(),
              const SizedBox(height: 60),
              _buildDoneButton(context, vm),
              _buildSaveButton(context, vm),
              _buildDeleteButton(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context, TodoDetailViewModel vm) {
    if (vm.isNew) return const SizedBox(height: 0);

    final _width = MediaQuery.of(context).size.width;
    // debugPrint('mediaquery width: ${_width.rune@timeType.toString()}');

    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () => {
            // vm.setState(Todo.findState('done')),
            // _update(context, vm),
            _done(context, vm),
          },
          child: Container(
            width: _width * 0.65,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Center(
              child: Text(
                '達成!!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            primary: Colors.white,
            onPrimary: Theme.of(context).primaryColorLight,
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, TodoDetailViewModel vm) {
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

  Widget _buildDeleteButton(BuildContext context, TodoDetailViewModel vm) {
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
  final TodoDetailViewModel vm;

  const TitleField({
    Key? key,
    required this.vm,
  }) : super(key: key);

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
              'ToDo',
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
            validator: (value) => value!.isEmpty ? 'ToDoを入力して' : null,
            onChanged: (value) => vm.setTitle(value),
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

class SliderField extends StatefulWidget {
  const SliderField({Key? key}) : super(key: key);

  @override
  _SliderField createState() => _SliderField();
}

class _SliderField extends State<SliderField> {
  int _score = 1;

  void initState() {
    super.initState();
    debugPrint('initstate☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆');
    // Utils.showTotalDoneScoreDialog(context, 8);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoDetailViewModel>(context);
    if (!vm.isNew) _score = vm.todo.score;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'スコア',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: Container(
              child: Slider(
                value: _score.toDouble(),
                onChanged: (value) {
                  _score = value.toInt();
                  vm.setScore(_score);
                },
                label: '$_score',
                min: 1,
                max: 5,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey[300],
                divisions: 4,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: CircleContainer(score: _score),
          ),
        ],
      ),
    );
  }
}

class CircleContainer extends StatefulWidget {
  final int score;

  const CircleContainer({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  _CircleContainerState createState() => _CircleContainerState();
}

class _CircleContainerState extends State<CircleContainer> {
  final _key = GlobalKey();
  double _width = 0; // ← lateだとダメ

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _width = _key.currentContext!.size!.width;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      width: _width,
      height: _width,
      child: Center(
        child: Text(
          widget.score.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(_width / 2)),
    );
  }
}
