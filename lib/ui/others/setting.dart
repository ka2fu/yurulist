import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/main.dart';
import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/util/home_utils.dart';
import 'package:yuruli/util/detail_utils.dart';
import 'package:yuruli/ui/todo/todo_list.dart';

class SettingPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SettingPage(),
    );
  }

  const SettingPage({
    Key? key,
  }) : super(key: key);

  static const List<String> types = ['expire', 'limit'];
  static const List<String> tmpTypes = ['tmp-ex', 'tmp-lim'];

  void _showUpdateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('設定を更新する?'),
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
                  '更新',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                onPressed: () => _update(context),
              ),
            ],
          );
        });
  }

  Future<void> _update(BuildContext context) async {
    Utils.showIndicator(context);

    tmpTypes.asMap().forEach((int index, String tmpType) async {
      await Preference.getIntValue(tmpType).then((value) {
        Preference.setRowInt(Setting.findState(types[index]), value);
      });
    });

    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
        title: const Text('設定'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            const SizedBox(height: 64),
            _showTotalScore(context),
            const SizedBox(height: 40),
            SliderField(type: types[0]),
            const SizedBox(height: 40),
            SliderField(type: types[1]),
            const SizedBox(height: 64),
            _buildUpdateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _showTotalScore(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('現在の獲得スコア'),
        const SizedBox(height: 16),
        FutureBuilder<int>(
          future: Preference.getIntValue(Todo.findState('tds')),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            // debugPrint('futureBuilder works');
            if (snapshot.hasData) {
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  snapshot.data.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('error: ${snapshot.error}');
            } else {
              return const Text('loading data...');
            }
          },
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showUpdateDialog(context),
      child: const Text(
        '更新',
        style: TextStyle(
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
}

class SliderField extends StatefulWidget {
  final String type;

  const SliderField({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _SliderFieldState createState() => _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  late String _type;
  late String _tmpKey;
  late int _max;
  late String _message;
  late String _unit;
  int _tmpValue = 1;
  int _value = 1;

  /// list<value, message, unit, tmpKey>
  final Map<String, List<dynamic>> types = {
    'expire': [7, 'ToDoリスト終了までの期間：', '日', 'tmp-ex'],
    'limit': [10, '習慣リストの最大個数：', '個', 'tmp-lim'],
  };

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    _max = types[_type]![0];
    _message = types[_type]![1];
    _unit = types[_type]![2];
    _tmpKey = types[_type]![3];

    Future(() async {
      await Preference.getIntValue(Setting.findState(_type)).then((value) {
        if (value == 0) {
          setState(() {
            _value = 1;
          });
        } else {
          setState(() {
            _value = value;
          });
        }
      });
      _tmpValue = _value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_message),
              SizedBox(
                width: 30,
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    _tmpValue.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    _unit,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                // flex: 15,
                child: Container(
                  child: Slider(
                    value: _tmpValue.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _tmpValue = value.toInt();
                      });
                      Preference.setRowInt(_tmpKey, _tmpValue);
                    },
                    label: '$_tmpValue',
                    min: 1,
                    max: _max.toDouble(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey[300],
                    divisions: _max - 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}