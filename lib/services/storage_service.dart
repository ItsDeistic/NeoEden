import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> save(String key, dynamic value) async {
    await init();
    final jsonStr = jsonEncode(value);
    await _prefs!.setString(key, jsonStr);
  }

  Future<dynamic> load(String key) async {
    await init();
    final jsonStr = _prefs!.getString(key);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr);
  }

  Future<void> remove(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  Future<void> clear() async {
    await init();
    await _prefs!.clear();
  }
}
