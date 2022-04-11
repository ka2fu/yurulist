import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:yuruli/util/home_utils.dart';

class Preference {
  static Future<int> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(key);
    if (value == null) return 0;
    return value;
  }

  static void setTodalDoneScore(String key, int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, score);
  }

  static void setIntValue(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var formatter = DateFormat(Utils.expireTimeFormat, 'ja-JP');
    int _value = int.parse(formatter.format(value));
    prefs.setInt(key, _value);
  }

  static void removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
