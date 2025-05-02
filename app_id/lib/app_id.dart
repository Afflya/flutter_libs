
import 'package:app_prefs/app_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AppId {
  ///
  /// Singleton
  ///

  static final AppId _singleton = AppId._internal();

  AppId._internal();

  static AppId get instance {
    return _singleton;
  }

  ///
  ///
  ///

  static const String _appIdKey = 'appId';

  String? _appId;

  Future<String> readAppId() async {
    return _appId ??= await initAppId();
  }

  Future<void> updateAppId(String appId) async {
    _appId = appId;
    try {
      await SecuredPrefs.instance.writeString(key: _appIdKey, value: appId);
    } catch (e) {
      debugPrint('failed to store app id error=$e');
    }
  }

  Future<String> initAppId() async {
    // Read value

    try {
      final String? storedAppId = await SecuredPrefs.instance.readString(_appIdKey);
      if (storedAppId != null) return storedAppId;
    } catch (e) {
      debugPrint('failed to read stored app id e=$e');
    }

    //generate new

    final String newAppId = Uuid().v4();

    //save generated

    await updateAppId(newAppId);

    return newAppId;
  }
}