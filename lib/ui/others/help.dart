import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      '・スコアは、そのToDoを達成したときにもらえる点数。気分で決めてください。',
      '  ∟ 難易度順とか、所要時間順とか、重要度順とかなんでもいいです。俺は、達成できたら嬉しい順で決めてます。',
      '・ToDoはスコア順に表示されます（降下順）。',
      '・ToDoリストの更新までの期間は設定から変更できます。',
      '  ∟ 更新期間は１日間から７日間の間で設定できます。',
      '・達成したToDoは、次の期間終了時に自動的にリストから削除されます。',
      '・削除されたToDoは、次の期間終了時まで未達成のToDoリスト一覧に表示されます。',
      '・ToDoを達成したら、次の期間終了時まで達成済みToDoリスト一覧に表示されます。',
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
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
