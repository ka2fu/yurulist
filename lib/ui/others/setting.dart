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
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () => _update(context),
              ),
            ],
          );
        });
  }

  void _update(BuildContext context) {
    Utils.showIndicator(context);
    Preference.setPeriod(SliderField.period);
    Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  }

  Future _buildTotalDoneScore(BuildContext context) async {
    late int totalDoneScore;
    await Preference.getIntValue(Todo.findState('tds')).then((value) {
      totalDoneScore = value;
    });

    return Text(
      totalDoneScore.toString(),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
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
          // mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            const SizedBox(height: 64),
            _showTotalScore(context),
            const SizedBox(height: 40),
            const SliderField(),
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
  const SliderField({Key? key}) : super(key: key);

  static int _period = 1;
  static int get period => _period;
  static void setPeriod(int value) {
    _period = value;
  }

  @override
  _SliderFieldState createState() => _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  int _period = SliderField.period;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await Preference.getIntValue(Setting.findState('expire')).then((value) {
        // debugPrint('expire period: $value');
        if (value == 0) {
          setState(() {
            _period = 1;
          });
        } else {
          setState(() {
            _period = value;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const Text('ToDoリスト終了までの期間：'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('ToDoリスト終了までの期間：'),
              SizedBox(
                width: 30,
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    // '${SliderField.period}',
                    _period.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '日',
                    style: TextStyle(
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
                    value: _period.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _period = value.toInt();
                      });
                      SliderField.setPeriod(_period);
                    },
                    label: '$_period',
                    min: 1,
                    max: 7,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey[300],
                    divisions: 6,
                  ),
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   // child: CircleContainer(score: _period),
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Text(
              //       '$_period日',
              //       style: const TextStyle(
              //         fontSize: 32,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

// class CircleContainer extends StatefulWidget {
//   final int score;

//   const CircleContainer({
//     Key? key,
//     required this.score,
//   }) : super(key: key);

//   @override
//   _CircleContainerState createState() => _CircleContainerState();
// }

// class _CircleContainerState extends State<CircleContainer> {
//   final _key = GlobalKey();
//   double _width = 0; // ← lateだとダメ

//   @override
//   void initState() {
//     SchedulerBinding.instance!.addPostFrameCallback((_) {
//       setState(() {
//         _width = _key.currentContext!.size!.width;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       key: _key,
//       width: _width,
//       height: _width,
//       child: Center(
//         child: Text(
//           // widget.score.toString(),
//           '${widget.score.toString()}日',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(_width / 2)),
//     );
//   }
// }
