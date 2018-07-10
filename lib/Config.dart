import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Config {
  SharedPreferences prefs;
  
  //SINGLETON
  static final Config _singleton = new Config._internal();

  factory Config() {
    return _singleton;
  }

  static Future<Config> get() async {
    if (_singleton.prefs == null) {
      _singleton.prefs = await SharedPreferences.getInstance();
    }
    
    return _singleton;
  }

  Config._internal();
//!SINGLETON

  static Future<String> getString(ConfigKeys key) async {
    var config = await get();
    return config.prefs.getString(key.toString());
  }


  static Future<bool> setString(ConfigKeys key, String value) async {
    var config = await get();
    return await config.prefs.setString(key.toString(), value);
  }
}

enum ConfigKeys {
  ACCESS_TOKEN,
  USER_EMAIL
}