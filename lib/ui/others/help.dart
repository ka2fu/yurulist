import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HelpPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const HelpPage(),
    );
  }

  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _hints = [
      '・スコアは、そのToDoを達成したときにもらえる点数。気分で決める',
      '・ToDoはスコア順に表示される（降下順）',
      '・登録した日に達成したToDoは、次の日自動的にリストから削除される',
      '・削除されたToDoは、1日だけ昨日のToDoリスト一覧に表示される',
      '・ToDoを達成したら、その日の間だけ達成済みToDoリスト一覧に表示される'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ヘルプ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(32),
        itemCount: _hints.length,
        itemBuilder: (BuildContext context, int index) {
          var hint = _hints[index];
          return _buildHints(context, hint);
        }
      ),
    );
  }

  Widget _buildHints(BuildContext context, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(hint),
    );
  }
}
