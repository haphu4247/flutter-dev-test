import 'package:shared_preferences/shared_preferences.dart';

enum PrefKey {
  loggedIn('logged_in'),
  accessToken('access_token'),
  refreshToken('refresh_token'),
  accessExp('access_exp'),
  profileJson('profile_json'),
  locale('locale'),
  theme('theme');

  const PrefKey(this.key);
  final String key;
}

class AppPrefs {
  AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPrefs> instance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AppPrefs(prefs);
  }

  bool getBool(PrefKey key, {bool defaultValue = false}) => _prefs.getBool(key.key) ?? defaultValue;
  Future<bool> setBool(PrefKey key, bool value) => _prefs.setBool(key.key, value);

  String? getString(PrefKey key) => _prefs.getString(key.key);
  Future<bool> setString(PrefKey key, String value) => _prefs.setString(key.key, value);

  int? getInt(PrefKey key) => _prefs.getInt(key.key);
  Future<bool> setInt(PrefKey key, int value) => _prefs.setInt(key.key, value);

  Future<bool> remove(PrefKey key) => _prefs.remove(key.key);

  bool containsKey(PrefKey key) => _prefs.containsKey(key.key);

  Future<bool> clear() => _prefs.clear();
}


