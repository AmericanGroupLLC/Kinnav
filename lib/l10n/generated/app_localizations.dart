import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('zh'),
    Locale('hi'),
    Locale('fr'),
    Locale('ar'),
  ];

  /// The app name. A brand name — leave untranslated.
  ///
  /// In en, this message translates to:
  /// **'Kinnav'**
  String get appTitle;

  /// Dismisses a dialog without acting.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Advances to the next onboarding slide.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// Skips the onboarding walkthrough.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// Finishes onboarding and enters the app.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get actionGetStarted;

  /// Button that opens the add-contact sheet.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kinnav'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'A new way of women safety and empowerment — help, anywhere, anytime.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingPressTitle.
  ///
  /// In en, this message translates to:
  /// **'Press a button'**
  String get onboardingPressTitle;

  /// No description provided for @onboardingPressBody.
  ///
  /// In en, this message translates to:
  /// **'Tap CALL GUARDIANS and choose voice, video, text or emergency to connect.'**
  String get onboardingPressBody;

  /// No description provided for @onboardingGuardiansTitle.
  ///
  /// In en, this message translates to:
  /// **'Guardians stay with you'**
  String get onboardingGuardiansTitle;

  /// No description provided for @onboardingGuardiansBody.
  ///
  /// In en, this message translates to:
  /// **'Vetted women nearby talk to you until you feel safe — no time limit, no judgment.'**
  String get onboardingGuardiansBody;

  /// No description provided for @onboardingRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow & get rewarded'**
  String get onboardingRewardsTitle;

  /// No description provided for @onboardingRewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Self-care modules and wellness rewards to help you flourish beyond safety.'**
  String get onboardingRewardsBody;

  /// Debug-only shortcut into the app. Not shown in release builds.
  ///
  /// In en, this message translates to:
  /// **'Demo mode (dev) — skip to app'**
  String get onboardingDemoMode;

  /// Title of the confirmation dialog shown before dialling emergency services.
  ///
  /// In en, this message translates to:
  /// **'Call emergency services ({number})?'**
  String emergencyConfirmTitle(String number);

  /// No description provided for @emergencyConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will place a real phone call to emergency services and keep your guardians on the Safe Call.'**
  String get emergencyConfirmBody;

  /// Confirm button. Placing the number in the label makes the consequence explicit.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String emergencyConfirmAction(String number);

  /// No description provided for @safeCallTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Call'**
  String get safeCallTitle;

  /// No description provided for @safeCallConnecting.
  ///
  /// In en, this message translates to:
  /// **'connecting…'**
  String get safeCallConnecting;

  /// Overlay shown while the call is being set up.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Connecting you to 1 guardian…} other{Connecting you to {count} guardians…}}'**
  String safeCallConnectingTo(int count);

  /// Shown whenever calls are simulated. This disclosure is a safety requirement — never hide or soften it.
  ///
  /// In en, this message translates to:
  /// **'DEMO · simulated safe call (no live video)'**
  String get safeCallSimulatedBadge;

  /// No description provided for @safeCallLiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Live safe call'**
  String get safeCallLiveBadge;

  /// No description provided for @safeCallAddPolice.
  ///
  /// In en, this message translates to:
  /// **'Add police'**
  String get safeCallAddPolice;

  /// Shown only after an emergency call has actually been placed.
  ///
  /// In en, this message translates to:
  /// **'Police added'**
  String get safeCallPoliceAdded;

  /// No description provided for @safeCallStartVideo.
  ///
  /// In en, this message translates to:
  /// **'Start Video'**
  String get safeCallStartVideo;

  /// No description provided for @safeCallStopVideo.
  ///
  /// In en, this message translates to:
  /// **'Stop Video'**
  String get safeCallStopVideo;

  /// No description provided for @safeCallSpeakerOn.
  ///
  /// In en, this message translates to:
  /// **'Turn On Speaker'**
  String get safeCallSpeakerOn;

  /// No description provided for @safeCallSpeakerOff.
  ///
  /// In en, this message translates to:
  /// **'Turn Off Speaker'**
  String get safeCallSpeakerOff;

  /// No description provided for @safeCallMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get safeCallMap;

  /// No description provided for @safeCallVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get safeCallVideo;

  /// No description provided for @safeCallCoachPolice.
  ///
  /// In en, this message translates to:
  /// **'Add the police to the call, if needed'**
  String get safeCallCoachPolice;

  /// No description provided for @safeCallCoachToggle.
  ///
  /// In en, this message translates to:
  /// **'Simply switch between map and video'**
  String get safeCallCoachToggle;

  /// No description provided for @safeCallCoachEnd.
  ///
  /// In en, this message translates to:
  /// **'Back to safety? Thank your guardians and end the call'**
  String get safeCallCoachEnd;

  /// No description provided for @safeCallNotifyingContacts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Opening a text to notify your 1 safety contact…} other{Opening a text to notify your {count} safety contacts…}}'**
  String safeCallNotifyingContacts(int count);

  /// Body of the SMS sent to safety contacts. {location} is either empty or a leading-space sentence with a map link.
  ///
  /// In en, this message translates to:
  /// **'Kinnav alert: I\'ve started a Safe Call and may need help.{location} Please check on me.'**
  String safeCallAlertMessage(String location);

  /// No description provided for @safeCallAlertLocation.
  ///
  /// In en, this message translates to:
  /// **' My live location: https://maps.google.com/?q={lat},{lng}.'**
  String safeCallAlertLocation(String lat, String lng);

  /// No description provided for @safetyContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Safety Contacts'**
  String get safetyContactsTitle;

  /// No description provided for @safetyContactsBlurb.
  ///
  /// In en, this message translates to:
  /// **'These trusted people are notified with your live location when you start a Safe Call.'**
  String get safetyContactsBlurb;

  /// No description provided for @safetyContactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet. Tap Add to invite someone.'**
  String get safetyContactsEmpty;

  /// No description provided for @safetyContactsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add safety contact'**
  String get safetyContactsAddTitle;

  /// No description provided for @safetyContactsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get safetyContactsName;

  /// No description provided for @safetyContactsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get safetyContactsPhone;

  /// No description provided for @safetyContactsAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get safetyContactsAddAction;

  /// Placeholder shown for a contact saved without a phone number.
  ///
  /// In en, this message translates to:
  /// **'No number'**
  String get safetyContactsNoNumber;

  /// Default relationship label for a manually added contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get safetyContactsRelation;

  /// The primary call-to-action on the map. Onboarding names this button, so the two must be translated consistently. Upper case in English; use whatever emphasis is natural for the language.
  ///
  /// In en, this message translates to:
  /// **'CALL GUARDIANS'**
  String get homeMapCallGuardians;

  /// No description provided for @callOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reach a Guardian'**
  String get callOptionsTitle;

  /// No description provided for @callOptionsBlurb.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to connect, then slide down.'**
  String get callOptionsBlurb;

  /// No description provided for @callOptionsSlide.
  ///
  /// In en, this message translates to:
  /// **'Slide Down'**
  String get callOptionsSlide;

  /// No description provided for @callOptionsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get callOptionsClose;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'hi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
