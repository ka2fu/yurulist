import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yuruli/ui/others/help.dart';
import 'package:yuruli/ui/others/setting.dart';

class StatusField extends StatelessWidget {
  // final DoneDetailViewModel vm;
  final String title;
  final String content;

  const StatusField({
    Key? key,
    // required this.vm,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              content,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Setting {
  static Map<String, String> states = {
    'expire': 'expirePeriod',
  };

  static findState(String str) {
    try {
      if (!states.containsKey(str)) throw Error;
      return states[str];
    } catch (e) {
      throw 'states key doesnt exist';
    }
  }
}
