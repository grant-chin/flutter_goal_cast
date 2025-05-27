// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd');

class GameController extends GetxController {
  static final freeKick = RxInt(3); // kick clash 免费次数
  static final freeShot = RxInt(3); // shot daily 免费次数

  // 初始化
  static init() {
    onInitKickFree();
    onInitShotFree();
  }

  // 初始化免费抽奖次数
  static onInitKickFree() {
    String time = SharePref.getString('freeKickTime') ?? '';
    String now = formater.format(DateTime.now());
    if (time == '' || time != now) {
      SharePref.setString('freeKickTime', '');
      freeKick.value = 3;
      SharePref.setInt('freeKick', 3);
    } else {
      freeKick.value = SharePref.getInt('freeKick');
    }
  }
  static onInitShotFree() {
    String time = SharePref.getString('freeShotTime') ?? '';
    String now = formater.format(DateTime.now());
    if (time == '' || time != now) {
      SharePref.setString('freeShotTime', '');
      freeShot.value = 3;
      SharePref.setInt('freeShot', 3);
    } else {
      freeShot.value = SharePref.getInt('freeShot');
    }
  }

  static onFreeKick() {
    if (freeKick.value == 0) return;
    String now = formater.format(DateTime.now());
    SharePref.setString('freeKickTime', now);
    freeKick.value--;
    SharePref.setInt('freeKick', freeKick.value);
  }
  static onFreeShot() {
    if (freeShot.value == 0) return;
    String now = formater.format(DateTime.now());
    SharePref.setString('freeShotTime', now);
    freeShot.value--;
    SharePref.setInt('freeShot', freeShot.value);
  }
}