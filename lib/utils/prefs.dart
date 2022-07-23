import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyEmpCode = 'empcode';
  static const _keyLoginStatus = '';
  static const _keyToken = 'fcmKey';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String empcode) async =>
      await _preferences!.setString(_keyEmpCode, empcode);

  static String? getUsername() => _preferences!.getString(_keyEmpCode);

  static Future setLogin(int lstats) async =>
      await _preferences!.setInt(_keyLoginStatus, lstats);

  static int? getLogin() => _preferences!.getInt(_keyLoginStatus);

  static Future setToken(String fcmToken) async =>
      await _preferences!.setString(_keyToken, fcmToken);

  static String? getToken() => _preferences!.getString(_keyToken);
}
