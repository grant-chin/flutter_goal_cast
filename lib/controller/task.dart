// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter_goal_cast/controller/user.dart';
import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd');

class TaskController extends GetxController {
  static final taskClaimed_1 = RxBool(false); // 任务1已领取
  static final taskClaimed_2 = RxBool(false); // 任务2已领取
  static final dailyClaimed = RxBool(false); // 每日奖励已领取

  // 初始化
  static init() {
    initTask();
  }

  static initTask() {
    String now = formater.format(DateTime.now());
    taskClaimed_1.value = SharePref.getString('claimedTime_1') == now;
    taskClaimed_2.value = SharePref.getString('claimedTime_2') == now;
    dailyClaimed.value = SharePref.getString('claimedTime_daily') == now;
  }
  // 领取任务1奖励
  static onClaimTask_1() {
    if (taskClaimed_1.value) return;
    String now = formater.format(DateTime.now());
    SharePref.setString('claimedTime_1', now);
    UserController.increasePoints(200);
    initTask();
  }
  // 领取任务2奖励
  static onClaimTask_2() {
    if (taskClaimed_2.value) return;
    String now = formater.format(DateTime.now());
    SharePref.setString('claimedTime_2', now);
    UserController.increaseXP(50);
    initTask();
  }

  static onClaimDaily() {
    String now = formater.format(DateTime.now());
    SharePref.setString('claimedTime_daily', now);
    initTask();
  }
}