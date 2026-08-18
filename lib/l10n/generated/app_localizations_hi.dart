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

  @override
  String get signUpTitle => 'Kinnav से जुड़ें';

  @override
  String get signUpSubtitle =>
      'अपने पास की गार्जियन से जुड़ने के लिए साइन इन करें।';

  @override
  String get signUpAgeConfirm =>
      'मैं पुष्टि करती हूँ कि मेरी उम्र 18 वर्ष या अधिक है';

  @override
  String get signUpLogIn => 'लॉग इन करें';

  @override
  String get signUpTestAccount => 'टेस्ट खाता इस्तेमाल करें';

  @override
  String get signUpOr => 'या';

  @override
  String get signUpApple => 'Apple से साइन इन करें';

  @override
  String get signUpGoogle => 'Google से जारी रखें';

  @override
  String get signUpLegalNote =>
      'जारी रखने पर आप हमारी शर्तों और गोपनीयता नीति से सहमत होती हैं।';

  @override
  String get drawerVersion => 'संस्करण 1.0.0';

  @override
  String get profileChooseFromLibrary => 'गैलरी से चुनें';

  @override
  String get profileTakePhoto => 'फ़ोटो लें';

  @override
  String get profileMyProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get profileNoProfile => 'कोई प्रोफ़ाइल नहीं';

  @override
  String get profileEditAction => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileDeleteAction => 'खाता हटाएँ';

  @override
  String get profileDeleteConfirmTitle => 'खाता हटाएँ?';

  @override
  String get profileDeleteConfirmBody =>
      'इससे आपकी प्रोफ़ाइल और डेटा इस डिवाइस से स्थायी रूप से हट जाएँगे।';

  @override
  String get profileDelete => 'हटाएँ';

  @override
  String get profileSetupProfile => 'आपकी प्रोफ़ाइल';

  @override
  String get profileSetupTellUsBitAbout => 'अपने बारे में थोड़ा बताएँ';

  @override
  String get profileSetupName => 'नाम';

  @override
  String get profileSetupContinueKinnav => 'Kinnav पर जारी रखें';

  @override
  String get profileEditProfileUpdated => 'प्रोफ़ाइल अपडेट हो गई।';

  @override
  String get profileEditEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileEditMonthYearBirth => 'जन्म का महीना और वर्ष';

  @override
  String get profileEditSpokenLanguages => 'बोली जाने वाली भाषाएँ';

  @override
  String get profileEditSaveChanges => 'बदलाव सहेजें';

  @override
  String get chatKinnavSupport => 'Kinnav सहायता';

  @override
  String get chatReplyTime => 'आमतौर पर 5 मिनट में जवाब';

  @override
  String get chatTypeMessage => 'संदेश लिखें…';

  @override
  String get callHistoryTitle => 'सेफ़ कॉल इतिहास';

  @override
  String get callHistoryEmpty =>
      'अभी तक कोई सेफ़ कॉल नहीं।\nगार्जियन के साथ आपकी पिछली कॉल यहाँ दिखेंगी।';

  @override
  String get callHistoryPolice => 'पुलिस';

  @override
  String get modulesSelfCare => 'सेल्फ़ केयर';

  @override
  String get moduleDetailLessons => 'पाठ';

  @override
  String get rewardsRewards => 'पुरस्कार';

  @override
  String get rewardsGetSafeGetRewarded => 'सुरक्षित रहें। पुरस्कार पाएँ।';

  @override
  String get rewardsRedeemed => 'भुनाया गया';

  @override
  String get rewardsRedeem => 'भुनाएँ';

  @override
  String get guardiansGuardians => 'गार्जियन';

  @override
  String get guardiansNearYou => 'आपके पास की गार्जियन';

  @override
  String get guardiansBecomeGuardian => 'गार्जियन बनें';

  @override
  String get guardiansVerifiedGuardian => 'आप एक सत्यापित गार्जियन हैं';

  @override
  String get guardiansAvailableHelp => 'मदद के लिए उपलब्ध';

  @override
  String get guardiansCalls => 'कॉल';

  @override
  String get guardiansHours => 'घंटे';

  @override
  String get guardiansEarnings => 'कमाई';

  @override
  String get guardiansPayoutNote =>
      'गार्जियन का भुगतान मासिक रूप से किया जाता है (चरण 6 — भुगतान)।';

  @override
  String get courseGuardianCourse => 'गार्जियन कोर्स';

  @override
  String get courseVerifiedGuardian => 'सत्यापित गार्जियन';

  @override
  String get subscriptionActivated => 'सदस्यता सक्रिय। स्वागत है! 💜';

  @override
  String get subscriptionNoPreviousPurchasesFound =>
      'कोई पिछली खरीद नहीं मिली।';

  @override
  String get subscriptionKinnavMembership => 'Kinnav सदस्यता';

  @override
  String get subscriptionJoinKinnavCommunity => 'Kinnav समुदाय से जुड़ें';

  @override
  String get subscriptionRestorePurchases => 'खरीद बहाल करें';

  @override
  String get subscriptionCancelMembership => 'सदस्यता रद्द करें';

  @override
  String get subscriptionActive => 'सक्रिय';

  @override
  String get feedbackAddRatingNoteFirst => 'पहले रेटिंग या टिप्पणी जोड़ें।';

  @override
  String get feedbackEmailOpened =>
      'आपका ईमेल ऐप खुला है — भेजें दबाएँ और हमें मिल जाएगा।';

  @override
  String get feedbackFeedback => 'प्रतिक्रिया';

  @override
  String get feedbackHowKinnavExperience => 'Kinnav का आपका अनुभव कैसा है?';

  @override
  String get feedbackHint =>
      'बताएँ आपको क्या पसंद है या हम क्या बेहतर कर सकते हैं…';

  @override
  String get feedbackSendFeedback => 'प्रतिक्रिया भेजें';

  @override
  String get howToHowUseKinnav => 'Kinnav कैसे इस्तेमाल करें';

  @override
  String get aboutAboutUs => 'हमारे बारे में';

  @override
  String get aboutSubtitle =>
      'महिलाओं की सुरक्षा और सशक्तिकरण का एक नया तरीका।';

  @override
  String get aboutSpreadingWord => 'बात फैलाएँ';

  @override
  String get aboutLegal => 'कानूनी';

  @override
  String get aboutTagline =>
      'आगे देखना आसान होता है जब आपको पीछे मुड़कर देखना न पड़े।';

  @override
  String get aboutTeam => 'हमारी टीम';

  @override
  String get aboutShivaniFounderSurvivor => 'शिवानी — संस्थापक और सर्वाइवर';

  @override
  String get aboutVishalFullStackEngineer => 'विशाल — फुल स्टैक इंजीनियर';

  @override
  String get aboutVanshikaMarketingDigitalNative =>
      'वंशिका — मार्केटिंग और डिजिटल नेटिव';

  @override
  String get legalLastUpdated => 'अंतिम अपडेट: 2026';

  @override
  String get coachDismissTip => 'सुझाव हटाएँ';

  @override
  String get guardiansBecomeBlurb =>
      '18+ की सत्यापित महिलाएँ 40 घंटे का एडवोकेसी कोर्स पूरा करती हैं, जो स्थानीय ग़ैर-लाभकारी संस्थाओं द्वारा ऑनलाइन कराया जाता है। वे ज़रूरतमंद महिलाओं से तब तक बात करती हैं जब तक वे सुरक्षित महसूस न करें — कोई समय सीमा नहीं, कोई आलोचना नहीं। गार्जियन को भुगतान मिलता है।';

  @override
  String get subscriptionBlurb =>
      'असीमित सेफ़ कॉल, सेल्फ़-केयर मॉड्यूल और विशेष वेलनेस पुरस्कार।';

  @override
  String get subscriptionDemoNotice =>
      'डेमो मोड — केवल सिम्युलेटेड खरीद। कोई वास्तविक शुल्क नहीं लिया जाता और App Store / Play बिलिंग का उपयोग नहीं होता।';

  @override
  String get aboutMission =>
      'Kinnav असुरक्षित परिस्थितियों में महिलाओं की मदद करता है, कहीं भी और कभी भी — उन्हें 10 मील के दायरे में सत्यापित गार्जियन से जोड़कर, और एक ऐसा समुदाय बनाकर जहाँ सभी महिलाएँ स्वतंत्र होकर आगे बढ़ सकें।';

  @override
  String get aboutSpreadingBlurb =>
      'कोई सवाल या सुझाव है, या दोस्तों और परिवार को हमारे बारे में बताना चाहती हैं? हमें फ़ॉलो करें और साझा करें:';

  @override
  String get drawerKinnavMember => 'Kinnav सदस्य';

  @override
  String get drawerGuardian => 'गार्जियन';

  @override
  String get drawerCommunityMember => 'समुदाय सदस्य';

  @override
  String get drawerInviteFriend => 'किसी मित्र को आमंत्रित करें';

  @override
  String get drawerInviteBody =>
      'Kinnav पर मुझसे जुड़ें — महिलाओं की सुरक्षा का ऐप। https://kinnav.com';

  @override
  String get drawerSelfCare => 'सेल्फ़ केयर और सशक्तिकरण';

  @override
  String get drawerMembership => 'सदस्यता';

  @override
  String get drawerContactUs => 'संपर्क करें';

  @override
  String get drawerContactSubject => 'Kinnav ऐप पूछताछ';

  @override
  String get drawerLogOut => 'लॉग आउट';
}
