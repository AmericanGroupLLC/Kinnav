// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => '取消';

  @override
  String get actionNext => '下一步';

  @override
  String get actionSkip => '跳过';

  @override
  String get actionGetStarted => '开始使用';

  @override
  String get actionAdd => '添加';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Kinnav';

  @override
  String get onboardingWelcomeBody => '守护女性安全与力量的全新方式——随时随地获得帮助。';

  @override
  String get onboardingPressTitle => '按下按钮';

  @override
  String get onboardingPressBody => '点按「呼叫守护者」，然后选择语音、视频、文字或紧急呼叫来建立联系。';

  @override
  String get onboardingGuardiansTitle => '守护者会一直陪着你';

  @override
  String get onboardingGuardiansBody =>
      '附近经过审核的女性会一直和你通话，直到你感到安全——没有时间限制，也不会评判你。';

  @override
  String get onboardingRewardsTitle => '成长并获得奖励';

  @override
  String get onboardingRewardsBody => '自我关怀课程与健康奖励，助你在安全之外持续成长。';

  @override
  String get onboardingDemoMode => '演示模式（开发）——直接进入应用';

  @override
  String emergencyConfirmTitle(String number) {
    return '拨打紧急服务电话（$number）？';
  }

  @override
  String get emergencyConfirmBody => '这将向紧急服务拨打真实电话，你的守护者会继续留在安全通话中。';

  @override
  String emergencyConfirmAction(String number) {
    return '拨打 $number';
  }

  @override
  String get safeCallTitle => '安全通话';

  @override
  String get safeCallConnecting => '正在连接…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在为你连接 $count 位守护者…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge => '演示 · 模拟安全通话（无实时视频）';

  @override
  String get safeCallLiveBadge => '实时安全通话';

  @override
  String get safeCallAddPolice => '加入警方';

  @override
  String get safeCallPoliceAdded => '已加入警方';

  @override
  String get safeCallStartVideo => '开启视频';

  @override
  String get safeCallStopVideo => '关闭视频';

  @override
  String get safeCallSpeakerOn => '打开扬声器';

  @override
  String get safeCallSpeakerOff => '关闭扬声器';

  @override
  String get safeCallMap => '地图';

  @override
  String get safeCallVideo => '视频';

  @override
  String get safeCallCoachPolice => '如有需要，可将警方加入通话';

  @override
  String get safeCallCoachToggle => '在地图与视频之间轻松切换';

  @override
  String get safeCallCoachEnd => '已经安全了吗？感谢你的守护者并结束通话';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在打开短信，通知你的 $count 位安全联系人…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'Kinnav 警报：我已发起安全通话，可能需要帮助。$location 请联系我确认我的情况。';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' 我的实时位置：https://maps.google.com/?q=$lat,$lng。';
  }

  @override
  String get safetyContactsTitle => '我的安全联系人';

  @override
  String get safetyContactsBlurb => '当你发起安全通话时，这些信任的人会收到你的实时位置。';

  @override
  String get safetyContactsEmpty => '还没有联系人。点按「添加」邀请他人。';

  @override
  String get safetyContactsAddTitle => '添加安全联系人';

  @override
  String get safetyContactsName => '姓名';

  @override
  String get safetyContactsPhone => '电话';

  @override
  String get safetyContactsAddAction => '添加联系人';

  @override
  String get safetyContactsNoNumber => '无号码';

  @override
  String get safetyContactsRelation => '联系人';

  @override
  String get homeMapCallGuardians => '呼叫守护者';

  @override
  String get callOptionsTitle => '联系守护者';

  @override
  String get callOptionsBlurb => '选择联系方式，然后向下滑动。';

  @override
  String get callOptionsSlide => '向下滑动';

  @override
  String get callOptionsClose => '关闭';
}
