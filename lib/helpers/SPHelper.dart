import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static SharedPreferences prefs;
  static void setPref(SharedPreferences prefs1) {
    prefs = prefs1;
  }

  static int getInt(String key) {
    return prefs.getInt(key) ?? 0;
  }

  static void setInt(String key, int value) {
    prefs.setInt(key, value);
    //prefs.commit();
  }

  static void setStringList(String key, List<String> lstCart) {
    prefs.setStringList(key, lstCart);
  }

  static List<String> getStringList(String key) {
    return (prefs.containsKey(key)) ? prefs.getString(key) : [];
  }

  static void removeCartList(String key) {
    var lst = [];
    prefs.setStringList(key, lst);
  }

  static String getString(String key) {
    return prefs.getString(key) ?? "";
  }

  static void setString(String key, String value) {
    prefs.setString(key, value);

    //prefs.commit();
  }

  static void logout() {
    prefs.clear();
  }
}
