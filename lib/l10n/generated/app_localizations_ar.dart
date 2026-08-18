// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionSkip => 'تخطٍ';

  @override
  String get actionGetStarted => 'ابدئي الآن';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get onboardingWelcomeTitle => 'مرحبًا بكِ في Kinnav';

  @override
  String get onboardingWelcomeBody =>
      'طريقة جديدة لأمان النساء وتمكينهنّ — مساعدة في أي مكان وفي أي وقت.';

  @override
  String get onboardingPressTitle => 'اضغطي زرًا واحدًا';

  @override
  String get onboardingPressBody =>
      'اضغطي على «الاتصال بالحاميات» واختاري مكالمة صوتية أو فيديو أو رسالة أو طوارئ للتواصل.';

  @override
  String get onboardingGuardiansTitle => 'الحاميات يبقين معكِ';

  @override
  String get onboardingGuardiansBody =>
      'نساء موثّقات قريبات منكِ يتحدثن معكِ حتى تشعري بالأمان — بلا حدود زمنية وبلا أحكام.';

  @override
  String get onboardingRewardsTitle => 'تطوّري واحصلي على مكافآت';

  @override
  String get onboardingRewardsBody =>
      'وحدات للعناية بالذات ومكافآت للعافية لتزدهري إلى ما هو أبعد من الأمان.';

  @override
  String get onboardingDemoMode =>
      'الوضع التجريبي (للمطوّرين) — الانتقال مباشرة إلى التطبيق';

  @override
  String emergencyConfirmTitle(String number) {
    return 'الاتصال بخدمات الطوارئ ($number)؟';
  }

  @override
  String get emergencyConfirmBody =>
      'سيتم إجراء مكالمة هاتفية حقيقية بخدمات الطوارئ وستبقى الحاميات على المكالمة الآمنة.';

  @override
  String emergencyConfirmAction(String number) {
    return 'اتصلي بـ $number';
  }

  @override
  String get safeCallTitle => 'المكالمة الآمنة';

  @override
  String get safeCallConnecting => 'جارٍ الاتصال…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ توصيلكِ بـ $count حامية…',
      many: 'جارٍ توصيلكِ بـ $count حامية…',
      few: 'جارٍ توصيلكِ بـ $count حاميات…',
      two: 'جارٍ توصيلكِ بحاميتين…',
      one: 'جارٍ توصيلكِ بحامية واحدة…',
      zero: 'جارٍ توصيلكِ بالحاميات…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge =>
      'تجريبي · مكالمة آمنة محاكاة (بدون فيديو مباشر)';

  @override
  String get safeCallLiveBadge => 'مكالمة آمنة مباشرة';

  @override
  String get safeCallAddPolice => 'إضافة الشرطة';

  @override
  String get safeCallPoliceAdded => 'تمت إضافة الشرطة';

  @override
  String get safeCallStartVideo => 'تشغيل الفيديو';

  @override
  String get safeCallStopVideo => 'إيقاف الفيديو';

  @override
  String get safeCallSpeakerOn => 'تشغيل مكبّر الصوت';

  @override
  String get safeCallSpeakerOff => 'إيقاف مكبّر الصوت';

  @override
  String get safeCallMap => 'الخريطة';

  @override
  String get safeCallVideo => 'الفيديو';

  @override
  String get safeCallCoachPolice => 'أضيفي الشرطة إلى المكالمة عند الحاجة';

  @override
  String get safeCallCoachToggle => 'بدّلي بسهولة بين الخريطة والفيديو';

  @override
  String get safeCallCoachEnd =>
      'عدتِ إلى الأمان؟ اشكري الحاميات وأنهي المكالمة';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ فتح رسالة لتنبيه $count جهة اتصال أمان…',
      many: 'جارٍ فتح رسالة لتنبيه $count جهة اتصال أمان…',
      few: 'جارٍ فتح رسالة لتنبيه $count جهات اتصال أمان…',
      two: 'جارٍ فتح رسالة لتنبيه جهتي اتصال الأمان…',
      one: 'جارٍ فتح رسالة لتنبيه جهة اتصال الأمان الخاصة بكِ…',
      zero: 'جارٍ فتح رسالة لتنبيه جهات الاتصال…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'تنبيه Kinnav: بدأتُ مكالمة آمنة وقد أحتاج إلى مساعدة.$location من فضلكم اطمئنّوا عليّ.';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' موقعي المباشر: https://maps.google.com/?q=$lat,$lng.';
  }

  @override
  String get safetyContactsTitle => 'جهات اتصال الأمان';

  @override
  String get safetyContactsBlurb =>
      'يتلقّى هؤلاء الأشخاص الموثوق بهم موقعكِ المباشر عند بدء مكالمة آمنة.';

  @override
  String get safetyContactsEmpty =>
      'لا توجد جهات اتصال بعد. اضغطي على «إضافة» لدعوة شخص ما.';

  @override
  String get safetyContactsAddTitle => 'إضافة جهة اتصال أمان';

  @override
  String get safetyContactsName => 'الاسم';

  @override
  String get safetyContactsPhone => 'الهاتف';

  @override
  String get safetyContactsAddAction => 'إضافة جهة الاتصال';

  @override
  String get safetyContactsNoNumber => 'بدون رقم';

  @override
  String get safetyContactsRelation => 'جهة اتصال';

  @override
  String get homeMapCallGuardians => 'الاتصال بالحاميات';

  @override
  String get callOptionsTitle => 'تواصلي مع حامية';

  @override
  String get callOptionsBlurb => 'اختاري طريقة التواصل ثم اسحبي للأسفل.';

  @override
  String get callOptionsSlide => 'اسحبي للأسفل';

  @override
  String get callOptionsClose => 'إغلاق';

  @override
  String get signUpTitle => 'انضمّي إلى Kinnav';

  @override
  String get signUpSubtitle =>
      'سجّلي الدخول للتواصل مع الحاميات القريبات منكِ.';

  @override
  String get signUpAgeConfirm => 'أؤكّد أن عمري 18 عامًا أو أكثر';

  @override
  String get signUpLogIn => 'تسجيل الدخول';

  @override
  String get signUpTestAccount => 'استخدام حساب تجريبي';

  @override
  String get signUpOr => 'أو';

  @override
  String get signUpApple => 'تسجيل الدخول عبر Apple';

  @override
  String get signUpGoogle => 'المتابعة عبر Google';

  @override
  String get signUpLegalNote =>
      'بالمتابعة فإنكِ توافقين على الشروط وسياسة الخصوصية.';

  @override
  String get drawerVersion => 'الإصدار 1.0.1';

  @override
  String get profileChooseFromLibrary => 'الاختيار من المعرض';

  @override
  String get profileTakePhoto => 'التقاط صورة';

  @override
  String get profileMyProfile => 'ملفي الشخصي';

  @override
  String get profileNoProfile => 'لا يوجد ملف شخصي';

  @override
  String get profileEditAction => 'تعديل الملف الشخصي';

  @override
  String get profileDeleteAction => 'حذف الحساب';

  @override
  String get profileDeleteConfirmTitle => 'حذف الحساب؟';

  @override
  String get profileDeleteConfirmBody =>
      'سيؤدي هذا إلى حذف ملفكِ الشخصي وبياناتكِ نهائيًا من هذا الجهاز.';

  @override
  String get profileDelete => 'حذف';

  @override
  String get profileSetupProfile => 'ملفكِ الشخصي';

  @override
  String get profileSetupTellUsBitAbout => 'أخبرينا قليلًا عنكِ';

  @override
  String get profileSetupName => 'الاسم';

  @override
  String get profileSetupContinueKinnav => 'المتابعة إلى Kinnav';

  @override
  String get profileEditProfileUpdated => 'تم تحديث الملف الشخصي.';

  @override
  String get profileEditEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileEditMonthYearBirth => 'شهر وسنة الميلاد';

  @override
  String get profileEditSpokenLanguages => 'اللغات التي تتحدثينها';

  @override
  String get profileEditSaveChanges => 'حفظ التغييرات';

  @override
  String get chatKinnavSupport => 'دعم Kinnav';

  @override
  String get chatReplyTime => 'يردّ عادةً خلال أقل من 5 دقائق';

  @override
  String get chatTypeMessage => 'اكتبي رسالة…';

  @override
  String get callHistoryTitle => 'سجل المكالمات الآمنة';

  @override
  String get callHistoryEmpty =>
      'لا توجد مكالمات آمنة بعد.\nستظهر هنا مكالماتكِ السابقة مع الحاميات.';

  @override
  String get callHistoryPolice => 'الشرطة';

  @override
  String get modulesSelfCare => 'العناية بالذات';

  @override
  String get moduleDetailLessons => 'الدروس';

  @override
  String get rewardsRewards => 'المكافآت';

  @override
  String get rewardsGetSafeGetRewarded => 'كوني بأمان. واحصلي على مكافآت.';

  @override
  String get rewardsRedeemed => 'تم الاستبدال';

  @override
  String get rewardsRedeem => 'استبدال';

  @override
  String get guardiansGuardians => 'الحاميات';

  @override
  String get guardiansNearYou => 'حاميات قريبات منكِ';

  @override
  String get guardiansBecomeGuardian => 'كوني حامية';

  @override
  String get guardiansVerifiedGuardian => 'أنتِ حامية موثّقة';

  @override
  String get guardiansAvailableHelp => 'متاحة للمساعدة';

  @override
  String get guardiansCalls => 'المكالمات';

  @override
  String get guardiansHours => 'الساعات';

  @override
  String get guardiansEarnings => 'الأرباح';

  @override
  String get guardiansPayoutNote =>
      'تُصرف مستحقات الحاميات شهريًا (المرحلة 6 — المدفوعات).';

  @override
  String get courseGuardianCourse => 'دورة الحاميات';

  @override
  String get courseVerifiedGuardian => 'حامية موثّقة';

  @override
  String get subscriptionActivated => 'العضوية مفعّلة. أهلًا بكِ! 💜';

  @override
  String get subscriptionNoPreviousPurchasesFound =>
      'لم يتم العثور على مشتريات سابقة.';

  @override
  String get subscriptionKinnavMembership => 'عضوية Kinnav';

  @override
  String get subscriptionJoinKinnavCommunity => 'انضمّي إلى مجتمع Kinnav';

  @override
  String get subscriptionRestorePurchases => 'استعادة المشتريات';

  @override
  String get subscriptionCancelMembership => 'إلغاء العضوية';

  @override
  String get subscriptionActive => 'مفعّلة';

  @override
  String get feedbackAddRatingNoteFirst => 'أضيفي تقييمًا أو ملاحظة أولًا.';

  @override
  String get feedbackEmailOpened => 'تطبيق البريد مفتوح — اضغطي إرسال وسيصلنا.';

  @override
  String get feedbackFeedback => 'ملاحظات';

  @override
  String get feedbackHowKinnavExperience => 'كيف كانت تجربتكِ مع Kinnav؟';

  @override
  String get feedbackHint => 'أخبرينا بما يعجبكِ أو بما يمكننا تحسينه…';

  @override
  String get feedbackSendFeedback => 'إرسال الملاحظات';

  @override
  String get howToHowUseKinnav => 'كيفية استخدام Kinnav';

  @override
  String get aboutAboutUs => 'من نحن';

  @override
  String get aboutSubtitle => 'طريقة جديدة لأمان النساء وتمكينهنّ.';

  @override
  String get aboutSpreadingWord => 'انشري الخبر';

  @override
  String get aboutLegal => 'الشؤون القانونية';

  @override
  String get aboutTagline =>
      'من الأسهل أن تتطلّعي إلى الأمام حين لا تضطرين إلى الالتفات خلفكِ.';

  @override
  String get aboutTeam => 'فريقنا';

  @override
  String get aboutShivaniFounderSurvivor => 'شيفاني — مؤسِّسة وناجية';

  @override
  String get aboutVishalFullStackEngineer => 'فيشال — مهندس برمجيات متكامل';

  @override
  String get aboutVanshikaMarketingDigitalNative =>
      'فانشيكا — التسويق والجيل الرقمي';

  @override
  String get legalLastUpdated => 'آخر تحديث: 2026';

  @override
  String get coachDismissTip => 'إخفاء التلميح';

  @override
  String get guardiansBecomeBlurb =>
      'نساء موثّقات بعمر 18 عامًا فأكثر يُكمِلن دورة مناصرة مدتها 40 ساعة، تُقدَّم عن بُعد من منظمات محلية غير ربحية. يتحدّثن مع النساء المحتاجات حتى يشعرن بالأمان — بلا حدود زمنية وبلا أحكام. وتحصل الحاميات على أجر.';

  @override
  String get subscriptionBlurb =>
      'مكالمات آمنة غير محدودة، ووحدات للعناية بالذات، ومكافآت عافية حصرية.';

  @override
  String get subscriptionDemoNotice =>
      'الوضع التجريبي — عملية شراء محاكاة فقط. لا يتم خصم أي مبلغ حقيقي ولا تُستخدم فوترة App Store أو Play.';

  @override
  String get aboutMission =>
      'يساعد Kinnav النساء في المواقف غير الآمنة، في أي مكان وأي وقت — بربطهنّ بحاميات موثّقات ضمن نطاق 16 كيلومترًا، وببناء مجتمع تزدهر فيه كل النساء بحرية.';

  @override
  String get aboutSpreadingBlurb =>
      'هل لديكِ أسئلة أو اقتراحات، أو تودّين تعريف صديقاتكِ وعائلتكِ بنا؟ تابعينا وشاركينا:';

  @override
  String get drawerKinnavMember => 'عضوة في Kinnav';

  @override
  String get drawerGuardian => 'حامية';

  @override
  String get drawerCommunityMember => 'عضوة في المجتمع';

  @override
  String get drawerInviteFriend => 'دعوة صديقة';

  @override
  String get drawerInviteBody =>
      'انضمّي إليّ على Kinnav، تطبيق لأمان النساء. https://kinnav.com';

  @override
  String get drawerSelfCare => 'العناية بالذات والتمكين';

  @override
  String get drawerMembership => 'العضوية';

  @override
  String get drawerContactUs => 'تواصلي معنا';

  @override
  String get drawerContactSubject => 'استفسار عن تطبيق Kinnav';

  @override
  String get drawerLogOut => 'تسجيل الخروج';

  @override
  String get signUpAgeRequired => 'عليكِ تأكيد أن عمركِ 18 عامًا أو أكثر.';

  @override
  String get signUpOffline =>
      'لا يوجد اتصال. تحقّقي من الشبكة وحاولي مرة أخرى.';

  @override
  String get signUpFailed =>
      'تعذّر تسجيل الدخول. تحقّقي من الاتصال وبيانات الدخول.';

  @override
  String get signUpUnavailable =>
      'تسجيل الدخول غير متاح حاليًا. حاولي مرة أخرى.';
}
