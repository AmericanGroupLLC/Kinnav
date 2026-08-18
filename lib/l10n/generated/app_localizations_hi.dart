// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionNext => 'आगे';

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get actionGetStarted => 'शुरू करें';

  @override
  String get actionAdd => 'जोड़ें';

  @override
  String get onboardingWelcomeTitle => 'Kinnav में आपका स्वागत है';

  @override
  String get onboardingWelcomeBody =>
      'महिलाओं की सुरक्षा और सशक्तिकरण का एक नया तरीका — कहीं भी, कभी भी मदद।';

  @override
  String get onboardingPressTitle => 'एक बटन दबाएँ';

  @override
  String get onboardingPressBody =>
      'गार्जियन को कॉल करें पर टैप करें और जुड़ने के लिए वॉइस, वीडियो, टेक्स्ट या आपातकाल चुनें।';

  @override
  String get onboardingGuardiansTitle => 'गार्जियन आपके साथ रहती हैं';

  @override
  String get onboardingGuardiansBody =>
      'आस-पास की सत्यापित महिलाएँ तब तक आपसे बात करती हैं जब तक आप सुरक्षित महसूस न करें — कोई समय सीमा नहीं, कोई आलोचना नहीं।';

  @override
  String get onboardingRewardsTitle => 'आगे बढ़ें और पुरस्कार पाएँ';

  @override
  String get onboardingRewardsBody =>
      'सेल्फ-केयर मॉड्यूल और वेलनेस रिवॉर्ड, ताकि आप सुरक्षा से आगे बढ़कर फल-फूल सकें।';

  @override
  String get onboardingDemoMode => 'डेमो मोड (dev) — सीधे ऐप में जाएँ';

  @override
  String emergencyConfirmTitle(String number) {
    return 'आपातकालीन सेवाओं ($number) को कॉल करें?';
  }

  @override
  String get emergencyConfirmBody =>
      'इससे आपातकालीन सेवाओं को एक वास्तविक फ़ोन कॉल की जाएगी और आपकी गार्जियन सेफ़ कॉल पर बनी रहेंगी।';

  @override
  String emergencyConfirmAction(String number) {
    return '$number पर कॉल करें';
  }

  @override
  String get safeCallTitle => 'सेफ़ कॉल';

  @override
  String get safeCallConnecting => 'कनेक्ट हो रहा है…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपको $count गार्जियन से जोड़ा जा रहा है…',
      one: 'आपको 1 गार्जियन से जोड़ा जा रहा है…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge =>
      'डेमो · सिम्युलेटेड सेफ़ कॉल (लाइव वीडियो नहीं)';

  @override
  String get safeCallLiveBadge => 'लाइव सेफ़ कॉल';

  @override
  String get safeCallAddPolice => 'पुलिस जोड़ें';

  @override
  String get safeCallPoliceAdded => 'पुलिस जोड़ी गई';

  @override
  String get safeCallStartVideo => 'वीडियो चालू करें';

  @override
  String get safeCallStopVideo => 'वीडियो बंद करें';

  @override
  String get safeCallSpeakerOn => 'स्पीकर चालू करें';

  @override
  String get safeCallSpeakerOff => 'स्पीकर बंद करें';

  @override
  String get safeCallMap => 'मानचित्र';

  @override
  String get safeCallVideo => 'वीडियो';

  @override
  String get safeCallCoachPolice => 'ज़रूरत हो तो कॉल में पुलिस को जोड़ें';

  @override
  String get safeCallCoachToggle => 'मानचित्र और वीडियो के बीच आसानी से बदलें';

  @override
  String get safeCallCoachEnd =>
      'सुरक्षित पहुँच गईं? अपनी गार्जियन को धन्यवाद दें और कॉल समाप्त करें';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपके $count सुरक्षा संपर्कों को सूचित करने के लिए संदेश खोला जा रहा है…',
      one: 'आपके 1 सुरक्षा संपर्क को सूचित करने के लिए संदेश खोला जा रहा है…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'Kinnav अलर्ट: मैंने सेफ़ कॉल शुरू की है और मुझे मदद की ज़रूरत हो सकती है।$location कृपया मेरा हाल पूछें।';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' मेरी लाइव लोकेशन: https://maps.google.com/?q=$lat,$lng.';
  }

  @override
  String get safetyContactsTitle => 'मेरे सुरक्षा संपर्क';

  @override
  String get safetyContactsBlurb =>
      'जब आप सेफ़ कॉल शुरू करती हैं, तो इन भरोसेमंद लोगों को आपकी लाइव लोकेशन भेजी जाती है।';

  @override
  String get safetyContactsEmpty =>
      'अभी कोई संपर्क नहीं। किसी को जोड़ने के लिए जोड़ें पर टैप करें।';

  @override
  String get safetyContactsAddTitle => 'सुरक्षा संपर्क जोड़ें';

  @override
  String get safetyContactsName => 'नाम';

  @override
  String get safetyContactsPhone => 'फ़ोन';

  @override
  String get safetyContactsAddAction => 'संपर्क जोड़ें';

  @override
  String get safetyContactsNoNumber => 'कोई नंबर नहीं';

  @override
  String get safetyContactsRelation => 'संपर्क';

  @override
  String get homeMapCallGuardians => 'गार्जियन को कॉल करें';

  @override
  String get callOptionsTitle => 'किसी गार्जियन से जुड़ें';

  @override
  String get callOptionsBlurb =>
      'चुनें कि आप कैसे जुड़ना चाहती हैं, फिर नीचे स्लाइड करें।';

  @override
  String get callOptionsSlide => 'नीचे स्लाइड करें';

  @override
  String get callOptionsClose => 'बंद करें';
}
