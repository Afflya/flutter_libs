library;

import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  ///
  /// Singleton
  ///

  static final AppPrefs _singleton = AppPrefs._internal();

  AppPrefs._internal();

  static AppPrefs get instance {
    return _singleton;
  }

  ///
  /// Read
  ///

  Future<String?> readString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> readInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double?> readDouble(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<bool?> readBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  ///
  /// Write
  ///

  Future<bool> writeString({
    required String key,
    required String? value,
  }) async {
    if (value == null) return remove(key);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<bool> writeInt({
    required String key,
    required int? value,
  }) async {
    if (value == null) return remove(key);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  Future<bool> writeDouble({
    required String key,
    required double? value,
  }) async {
    if (value == null) return remove(key);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  Future<bool> writeBool({
    required String key,
    required bool? value,
  }) async {
    if (value == null) return remove(key);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  ///
  /// Options
  ///

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<void> removeByPrefix(String prefix) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((element) => element.startsWith(prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}

class SecuredPrefs {
  ///
  /// Singleton
  ///

  static final SecuredPrefs _singleton = SecuredPrefs._internal();

  SecuredPrefs._internal();

  static SecuredPrefs get instance {
    return _singleton;
  }

  ///
  /// Init
  ///

  static bool get platformSupported => Platform.isAndroid || Platform.isIOS;

  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static const _storage = FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  ///
  /// Read
  ///

  Future<String?> readString(String key) async {
    if (!platformSupported) {
      return AppPrefs.instance.readString(key);
    }
    try {
      final String? value = await _storage.read(key: key);
      return value;
    } catch (_) {
      return null;
    }
  }

  Future<int?> readInt(String key) async {
    final String? value = await readString(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  Future<double?> readDouble(String key) async {
    final String? value = await readString(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  Future<bool?> readBool(String key) async {
    final String? value = await readString(key);
    if (value == null) return null;
    return bool.tryParse(value);
  }

  ///
  /// Write
  ///

  Future<bool> writeString({
    required String key,
    required String? value,
  }) async {
    if (!platformSupported) {
      return AppPrefs.instance.writeString(key: key, value: value);
    }
    try {
      if (value == null) {
        await _storage.delete(key: key);
        return true;
      }
      await _storage.write(key: key, value: value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> writeInt({
    required String key,
    required int? value,
  }) async {
    return writeString(key: key, value: value.toString());
  }

  Future<bool> writeDouble({
    required String key,
    required double? value,
  }) async {
    return writeString(key: key, value: value.toString());
  }

  Future<bool> writeBool({
    required String key,
    required bool? value,
  }) async {
    return writeString(key: key, value: value.toString());
  }

  ///
  /// Options
  ///

  Future<bool> remove(String key) async {
    if (!platformSupported) {
      return AppPrefs.instance.remove(key);
    }
    try {
      await _storage.delete(key: key);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> removeByPrefix(String prefix) async {
    if (!platformSupported) {
      return AppPrefs.instance.removeByPrefix(prefix);
    }
    try {
      final keys = (await _storage.readAll()).keys.where((e) => e.startsWith(prefix));
      for (final key in keys) {
        await remove(key);
      }
      return;
    } catch (_) {
      return;
    }
  }

  Future<bool> clear() async {
    if (!platformSupported) {
      return AppPrefs.instance.clear();
    }
    try {
      await _storage.deleteAll();
      return true;
    } catch (_) {
      return false;
    }
  }
}
