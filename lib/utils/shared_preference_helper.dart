import 'package:shared_preferences/shared_preferences.dart';

import 'SharedPrefsKeys.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences> _sharedPreference;

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  //Theme module
  Future<void> changeTheme(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(SharedPrefsKeys.is_dark_mode, value);
    });
  }

  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(SharedPrefsKeys.is_dark_mode) ?? false;
    });
  }

  //Locale module
  Future<String> get appLocale {
    return _sharedPreference.then((prefs) {
      return prefs.getString(SharedPrefsKeys.language_code) ?? null;
    });
  }

  Future<void> changeLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(SharedPrefsKeys.language_code, value);
    });
  }
}
