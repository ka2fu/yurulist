import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/ui/yesterday/yesterday_detail.dart';
import 'package:yuruli/ui/others/setting.dart';
import 'package:yuruli/ui/others/help.dart';

class YesterdayList extends StatelessWidget {
  static int get index => 2;

  const YesterdayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).push<dynamic>(HelpPage.route()),
          icon: const FaIcon(FontAwesomeIcons.circleQuestion),
        ),
        title: const Text(
          'yesterday',
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
      body: Center(
        child: ElevatedButton(
          child: const Text('yesterday'),
          onPressed: () =>
              Navigator.of(context).push<dynamic>(YesterdayDetailPage.route()),
        ),
      ),
    );
  }
}
