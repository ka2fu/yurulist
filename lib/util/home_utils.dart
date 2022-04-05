import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ↓使えない
class HomeAppBar extends StatelessWidget {
  final String title;

  const HomeAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => {},
        icon: const FaIcon(FontAwesomeIcons.circleQuestion),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () => {},
          icon: const FaIcon(FontAwesomeIcons.gear),
        ),
      ],
    );
  }
}

class Utils {
  static int todayExpireDiff = 1;
  static int yesterdayExpireDiff = 1;
  static String expireTimeFormat = 'yyyyMMddHHmm';

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
}
