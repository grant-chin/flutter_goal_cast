import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static late SharedPreferences _prefs;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  // string
  static getString(key) {
    return _prefs.getString(key);
  }
  static setString(key, value) {
    _prefs.setString(key, value);
  }
  // int
  static getInt(key) {
    return _prefs.getInt(key);
  }
  static setInt(key, value) {
    _prefs.setInt(key, value);
  }
  // double
  static getDouble(key) {
    return _prefs.getDouble(key);
  }
  static setDouble(key, value) {
    _prefs.setDouble(key, value);
  }
  // bool
  static getBool(key) {
    return _prefs.getBool(key);
  }
  static setBool(key, value) {
    _prefs.setBool(key, value);
  }
  // stringList
  static getStringList(key) {
    return _prefs.getStringList(key);
  }
  static setStringList(key, value) {
    _prefs.setStringList(key, value);
  }

  // 清理数据
  static clear() {
    _prefs.clear();
  }
}