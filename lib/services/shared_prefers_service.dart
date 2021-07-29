import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> setStringList({String? key, List<String>? stringList}) async {
    final SharedPreferences prefs = await _prefs;
    bool boolResult = await prefs.setStringList(key!, stringList!);
    return boolResult;
  }

  Future<List<String>> getStringList({String? key}) async {
    final SharedPreferences prefs = await _prefs;

    bool containsKey = prefs.containsKey(key!);
    if (containsKey) {
      List<String>? stringList = prefs.getStringList(key);
      return stringList!;
    }
    return <String>[];
  }
}
