// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd');

class UserController extends GetxController {
  static final first = RxBool(true); // 第一次打开
  static final level = RxInt(1); // 等级
  static final xp = RxInt(0); // 当前经验
  static final xpAll = RxInt(0); // 所有经验
  static final xpUp = RxInt(0); // 升级所需经验
  static final points = RxInt(0); // 积分
  static final claimList = RxList([]);

  static final freeCount = RxInt(3); // 免费次数

  // 初始化
  static init() {
    level.value = SharePref.getInt('level') ?? 1;
    xp.value = SharePref.getInt('xp') ?? 0;
    xpAll.value = SharePref.getInt('xpAll') ?? 0;
    points.value = SharePref.getInt('points') ?? 0;
    first.value = SharePref.getBool('first') == false ? false : true;
    onInitFree();
  }

  // 第一次使用
  static onFirstUse() {
    first.value = false;
    SharePref.setBool('first', false);
  }

  // 初始化免费抽奖次数
  static onInitFree() {
    String time = SharePref.getString('freeTime') ?? '';
    String now = formater.format(DateTime.now());
    if (time == '' || time != now) {
      freeCount.value = 3;
      SharePref.setString('freeTime', '');
      SharePref.setInt('freeCount', 3);
    } else {
      freeCount.value = SharePref.getInt('freeCount');
    }
  }
  // 完成免费抽奖
  static onFreeSpin() {
    if (freeCount.value == 0) return;
    String now = formater.format(DateTime.now());
    SharePref.setString('freeTime', now);
    freeCount.value--;
    SharePref.setInt('freeCount', freeCount.value);
  }

  //增加经验
  static increaseXP(int value) {
    xpAll.value += value;
    xp.value += value;
    SharePref.setInt('xp', xp.value);
    SharePref.setInt('xpAll', xpAll.value);
  }
  // 增加积分
  static increasePoints(int value) {
    points.value += value;
    SharePref.setInt('points', points.value);
  }
  // 减少积分
  static decreasePoints(int value) {
    points.value -= value;
    SharePref.setInt('points', points.value);
  }
}