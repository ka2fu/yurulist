import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SettingPage(),
    );
  }

  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: const Center(
        child: Text('設定'),
      ),
    );
  }
}
