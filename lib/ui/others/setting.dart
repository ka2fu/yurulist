import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/model/preference_data.dart';
import 'package:yuruli/model/entity/todo.dart';
import 'package:yuruli/util/home_utils.dart';

class SettingPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SettingPage(),
    );
  }

  const SettingPage({
    Key? key,
  }) : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('現在の獲得スコア'),
            const SizedBox(height: 16),
            FutureBuilder<int>(
              future: Preference.getIntValue(Todo.findState('tds')),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                // Text text;
                debugPrint('futureBuilder works');
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
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
        ),
      ),
    );
  }
}
