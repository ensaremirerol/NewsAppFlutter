import 'package:flutter/cupertino.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'dart:async';

// Cihaz hafızasına küçük bilgileri yazabilir, okuyabilir ve silebilir
class SharedPreferencesManager {
  static void saveData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      debugPrint("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<bool> deleteData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
