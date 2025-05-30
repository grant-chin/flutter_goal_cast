// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd');

class UserController extends GetxController {
  static final first = RxBool(true); // 第一次打开
  static final avator = RxString(''); // 头像
  static final nickname = RxString(''); // 昵称
  static final level = RxInt(1); // 等级
  static final xp = RxInt(0); // 当前经验
  static final xpAll = RxInt(0); // 所有经验
  static final points = RxInt(0); // 积分
  static final pointStr = RxString('0'); // 积分-格式化

  // 初始化
  static init() {
    avator.value = SharePref.getString('avator') ?? '';
    nickname.value = SharePref.getString('nickname') ?? 'Thomas';
    level.value = SharePref.getInt('level') ?? 1;
    xp.value = SharePref.getInt('xp') ?? 0;
    xpAll.value = SharePref.getInt('xpAll') ?? 0;
    points.value = SharePref.getInt('points') ?? 0;
    pointStr.value = pointFormat(points.value);
    first.value = SharePref.getBool('first') == false ? false : true;
  }

  // 第一次使用
  static onFirstUse() {
    first.value = false;
    SharePref.setBool('first', false);
  }

  //增加经验
  static increaseXP(int value) {
    xpAll.value += value;
    if (xp.value + value >= 500) {
      xp.value = xp.value + value % 500;
      level.value += xp.value + value ~/ 500;
      SharePref.setInt('level', level.value);
    } else {
      xp.value += value;
    }
    SharePref.setInt('xp', xp.value);
    SharePref.setInt('xpAll', xpAll.value);
  }
  // 增加积分
  static increasePoints(int value) {
    points.value += value;
    SharePref.setInt('points', points.value);
    pointStr.value = pointFormat(points.value);
  }
  // 减少积分
  static decreasePoints(int value) {
    points.value -= value;
    SharePref.setInt('points', points.value);
    pointStr.value = pointFormat(points.value);
  }
  // 积分货币格式化
  static pointFormat(value) {
    return NumberFormat('#,###').format(value);
  }
}