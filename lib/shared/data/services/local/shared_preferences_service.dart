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

class SharedPreferencesService {
  const SharedPreferencesService();

  Future<bool> getBool(PrefKey key, {bool defaultValue = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key.key) ?? defaultValue;
  }

  Future<bool> setBool(PrefKey key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key.key, value);
  }

  Future<String?> getString(PrefKey key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.key);
  }

  Future<bool> setString(PrefKey key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key.key, value);
  }

  Future<int?> getInt(PrefKey key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key.key);
  }

  Future<bool> setInt(PrefKey key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key.key, value);
  }

  Future<bool> remove(PrefKey key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key.key);
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
