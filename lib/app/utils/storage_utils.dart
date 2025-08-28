// lib/core/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Generic save
  static Future<bool> save(String key, dynamic value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (value is String) return _prefs.setString(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is List<String>) return _prefs.setStringList(key, value);
    throw Exception('Unsupported type');
  }

  // Generic read
  static read(String key) async {
    print('------------------------$key----------------------');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var value = _prefs.get(key);
    print('------------------------$key----------------------');
    print(value.toString());
    print('------------------------$key----------------------');
    return value;
  }

  // // Specific examples
  // String? get token => _prefs.getString('auth_token');
  // Future<bool> setToken(String value) => _prefs.setString('auth_token', value);

  static Future<bool> remove(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.remove(key);
  }
}
