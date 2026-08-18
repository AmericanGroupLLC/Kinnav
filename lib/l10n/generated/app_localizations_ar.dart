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
}
