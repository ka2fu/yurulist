import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yuruli/main.dart';
import 'package:yuruli/ui/yesterday/yesterday_list.dart';
import 'package:yuruli/util/home_utils.dart';

class YesterdayDetailPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const YesterdayDetailPage(),
    );
  }

  const YesterdayDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Utils.goToHomeScreen(
              context, HomePage(removeUntilIndex: YesterdayList.index)),
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
        ),
        title: const Text(
          'yesterday detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('yesterday detail'),
      ),
    );
  }
}
