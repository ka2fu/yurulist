import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Preference {
  // static getInt(String key) async {
  //   late int value;
  //   await _getIntValue(key).then((int res) {
  //     value = res;
  //   });
  //   return value;
  // }

  static Future<int> getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(key);
    if (value == null) return 0;
    return value;
  }

  static void setIntValue(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var formatter = DateFormat('yyyyMMddHHmm', 'ja-JP');
    int _value = int.parse(formatter.format(value));
    prefs.setInt(key, _value);
  }

  static void removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
