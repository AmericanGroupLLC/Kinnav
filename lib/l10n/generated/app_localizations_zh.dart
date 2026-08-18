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

  @override
  String get signUpTitle => '加入 Kinnav';

  @override
  String get signUpSubtitle => '登录以联系你附近的守护者。';

  @override
  String get signUpAgeConfirm => '我确认我已年满 18 周岁';

  @override
  String get signUpLogIn => '登录';

  @override
  String get signUpTestAccount => '使用测试账号';

  @override
  String get signUpOr => '或';

  @override
  String get signUpApple => '通过 Apple 登录';

  @override
  String get signUpGoogle => '通过 Google 继续';

  @override
  String get signUpLegalNote => '继续即表示你同意我们的条款和隐私政策。';

  @override
  String get drawerVersion => '版本 1.0.1';

  @override
  String get profileChooseFromLibrary => '从相册选择';

  @override
  String get profileTakePhoto => '拍照';

  @override
  String get profileMyProfile => '我的资料';

  @override
  String get profileNoProfile => '暂无资料';

  @override
  String get profileEditAction => '编辑资料';

  @override
  String get profileDeleteAction => '删除账号';

  @override
  String get profileDeleteConfirmTitle => '删除账号？';

  @override
  String get profileDeleteConfirmBody => '此操作将从本设备永久删除你的资料和数据。';

  @override
  String get profileDelete => '删除';

  @override
  String get profileSetupProfile => '你的资料';

  @override
  String get profileSetupTellUsBitAbout => '简单介绍一下你自己';

  @override
  String get profileSetupName => '姓名';

  @override
  String get profileSetupContinueKinnav => '继续前往 Kinnav';

  @override
  String get profileEditProfileUpdated => '资料已更新。';

  @override
  String get profileEditEditProfile => '编辑资料';

  @override
  String get profileEditMonthYearBirth => '出生年月';

  @override
  String get profileEditSpokenLanguages => '使用的语言';

  @override
  String get profileEditSaveChanges => '保存更改';

  @override
  String get chatKinnavSupport => 'Kinnav 支持';

  @override
  String get chatReplyTime => '通常 5 分钟内回复';

  @override
  String get chatTypeMessage => '输入消息…';

  @override
  String get callHistoryTitle => '安全通话记录';

  @override
  String get callHistoryEmpty => '还没有安全通话。\n你与守护者的通话记录将显示在这里。';

  @override
  String get callHistoryPolice => '警方';

  @override
  String get modulesSelfCare => '自我关怀';

  @override
  String get moduleDetailLessons => '课程';

  @override
  String get rewardsRewards => '奖励';

  @override
  String get rewardsGetSafeGetRewarded => '保障安全，赢得奖励。';

  @override
  String get rewardsRedeemed => '已兑换';

  @override
  String get rewardsRedeem => '兑换';

  @override
  String get guardiansGuardians => '守护者';

  @override
  String get guardiansNearYou => '你附近的守护者';

  @override
  String get guardiansBecomeGuardian => '成为守护者';

  @override
  String get guardiansVerifiedGuardian => '你已是认证守护者';

  @override
  String get guardiansAvailableHelp => '可提供帮助';

  @override
  String get guardiansCalls => '通话';

  @override
  String get guardiansHours => '小时';

  @override
  String get guardiansEarnings => '收入';

  @override
  String get guardiansPayoutNote => '守护者的报酬按月结算（第 6 阶段 — 支付）。';

  @override
  String get courseGuardianCourse => '守护者课程';

  @override
  String get courseVerifiedGuardian => '认证守护者';

  @override
  String get subscriptionActivated => '会员已生效。欢迎！💜';

  @override
  String get subscriptionNoPreviousPurchasesFound => '未找到以往的购买记录。';

  @override
  String get subscriptionKinnavMembership => 'Kinnav 会员';

  @override
  String get subscriptionJoinKinnavCommunity => '加入 Kinnav 社区';

  @override
  String get subscriptionRestorePurchases => '恢复购买';

  @override
  String get subscriptionCancelMembership => '取消会员';

  @override
  String get subscriptionActive => '生效中';

  @override
  String get feedbackAddRatingNoteFirst => '请先添加评分或留言。';

  @override
  String get feedbackEmailOpened => '你的邮件应用已打开——点击发送，我们就会收到。';

  @override
  String get feedbackFeedback => '反馈';

  @override
  String get feedbackHowKinnavExperience => '你在 Kinnav 的体验如何？';

  @override
  String get feedbackHint => '告诉我们你喜欢什么，或者我们可以改进什么…';

  @override
  String get feedbackSendFeedback => '发送反馈';

  @override
  String get howToHowUseKinnav => '如何使用 Kinnav';

  @override
  String get aboutAboutUs => '关于我们';

  @override
  String get aboutSubtitle => '守护女性安全与力量的全新方式。';

  @override
  String get aboutSpreadingWord => '帮我们传播';

  @override
  String get aboutLegal => '法律条款';

  @override
  String get aboutTagline => '当你不必时刻提防身后时，向前看会更容易。';

  @override
  String get aboutTeam => '我们的团队';

  @override
  String get aboutShivaniFounderSurvivor => 'Shivani — 创始人、幸存者';

  @override
  String get aboutVishalFullStackEngineer => 'Vishal — 全栈工程师';

  @override
  String get aboutVanshikaMarketingDigitalNative => 'Vanshika — 市场与数字原生一代';

  @override
  String get legalLastUpdated => '最后更新：2026';

  @override
  String get coachDismissTip => '关闭提示';

  @override
  String get guardiansBecomeBlurb =>
      '经过审核的 18 岁以上女性完成 40 小时的倡导课程，由当地非营利组织在线培训。她们会一直与需要帮助的女性通话，直到对方感到安全——没有时间限制，也不会评判。守护者可获得报酬。';

  @override
  String get subscriptionBlurb => '无限次安全通话、自我关怀课程和专属健康奖励。';

  @override
  String get subscriptionDemoNotice =>
      '演示模式——仅为模拟购买。不会产生任何实际费用，也不使用 App Store / Play 的支付服务。';

  @override
  String get aboutMission =>
      'Kinnav 随时随地帮助身处不安全处境的女性——将她们与 10 英里范围内经过审核的守护者相连，并建立一个让所有女性都能自由成长的社区。';

  @override
  String get aboutSpreadingBlurb => '有疑问或建议，或者想让亲友知道我们？欢迎关注并分享：';

  @override
  String get drawerKinnavMember => 'Kinnav 会员';

  @override
  String get drawerGuardian => '守护者';

  @override
  String get drawerCommunityMember => '社区成员';

  @override
  String get drawerInviteFriend => '邀请朋友';

  @override
  String get drawerInviteBody => '和我一起使用 Kinnav——一款女性安全应用。https://kinnav.com';

  @override
  String get drawerSelfCare => '自我关怀与成长';

  @override
  String get drawerMembership => '会员';

  @override
  String get drawerContactUs => '联系我们';

  @override
  String get drawerContactSubject => 'Kinnav 应用咨询';

  @override
  String get drawerLogOut => '退出登录';

  @override
  String get signUpAgeRequired => '你必须确认已年满 18 周岁。';

  @override
  String get signUpOffline => '无网络连接。请检查网络后重试。';

  @override
  String get signUpFailed => '无法登录。请检查网络和账号信息。';

  @override
  String get signUpUnavailable => '当前无法登录，请稍后重试。';
}
