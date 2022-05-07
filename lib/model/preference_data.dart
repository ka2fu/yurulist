import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:yuruli/util/home_utils.dart';
import 'package:yuruli/util/detail_utils.dart';

class Preference {
  static Future<int> getIntValue(String key) async {
    // debugPrint('preference getIntValue works');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(key);
    // debugPrint('value in getIntValue: $value');
    if (value == null) return 0;
    return value;
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    if (value == null) return '';
    return value;
  }

  static void setTodalDoneScore(String key, int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, score);
  }

  static void setTimeString(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var formatter = DateFormat('yyyy/MM/dd', 'ja-JP');
    var time = formatter.format(value);
    prefs.setString(key, time);
  }

  static void setIntValue(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var formatter = DateFormat(Utils.expireTimeFormat, 'ja-JP');
    int _value = int.parse(formatter.format(value));
    prefs.setInt(key, _value);
  }

  static void setRowInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static void setTimeInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static void removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
