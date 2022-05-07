import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yuruli/ui/others/help.dart';
import 'package:yuruli/ui/others/setting.dart';

class HomeAppBar extends AppBar {
  final String screenTitle;

  HomeAppBar({
    Key? key,
    required this.screenTitle,
  });

  PreferredSizeWidget builder(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).push<dynamic>(HelpPage.route()),
        icon: const FaIcon(FontAwesomeIcons.circleQuestion),
      ),
      title: Text(
        screenTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () =>
              Navigator.of(context).push<dynamic>(SettingPage.route()),
          icon: const FaIcon(FontAwesomeIcons.gear),
        ),
      ],
    );
  }
}

class Utils {
  static int _todayExpireDiff = 1;
  static int _yesterdayExpireDiff = 2;
  static int get todayExpireDiff => _todayExpireDiff;
  static int get yesterdayExpireDiff => _yesterdayExpireDiff;
  static void setExpireDiff(value) {
    _todayExpireDiff = value;
    _yesterdayExpireDiff = value * 2;
  }

  static String expireTimeFormat = 'yyyyMMddHHmm'; // 期限のフォーマット

  static void showIndicator(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // ← これ何？
      transitionDuration: const Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (
        BuildContext context,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Utils.goToHomeScreen(context, HomePage(removeUntilIndex: TodoList.index));
  static void goToHomeScreen(BuildContext context, dynamic toPage) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => toPage,
      ),
      (route) => false,
    );
  }

  static showCustomLimitDialog(BuildContext context, int limit) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '*設定できる習慣は$limit個までです。',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  static Future showTotalDoneScoreDialog(
      BuildContext context, int score, String time) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${time.toString()}の獲得スコア'),
          content: Text(
            score.toString(),
            style: TextStyle(
              fontSize: width * 2 / 5,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
