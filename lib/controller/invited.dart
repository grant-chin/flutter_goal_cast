// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names

import 'package:intl/intl.dart';
import '/common/share_pref.dart';
import 'package:get/get.dart';

var formater = DateFormat('yyyy-MM-dd');

class InvitedController extends GetxController {
  static final invitedCount = RxInt(0); // 分享次数
  static final claimList = RxList(); // 已领取列表

  // 初始化
  static init() {
    invitedCount.value = SharePref.getInt('invitedCount') ?? 0;
    claimList.value = SharePref.getString('claimList') == null ? [] : SharePref.getString('claimList').split(',').map(int.parse).toList();
  }

  // 分享
  static onShare() {
    invitedCount.value += 1;
    SharePref.setInt('invitedCount', invitedCount.value);
  }
  // 领取奖励
  static onClaim(index) {
    if (claimList.contains(index)) return;
    claimList.add(index);
    SharePref.setInt('claimList', claimList.join(','));
  }
}