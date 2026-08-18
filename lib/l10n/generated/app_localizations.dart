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

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Kinnav'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to connect with guardians near you.'**
  String get signUpSubtitle;

  /// 18+ gate. Kinnav is 18+ only, so this wording is a legal requirement.
  ///
  /// In en, this message translates to:
  /// **'I confirm I am 18 years or older'**
  String get signUpAgeConfirm;

  /// No description provided for @signUpLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get signUpLogIn;

  /// No description provided for @signUpTestAccount.
  ///
  /// In en, this message translates to:
  /// **'Use test account'**
  String get signUpTestAccount;

  /// Divider between password sign-in and the OAuth buttons.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get signUpOr;

  /// No description provided for @signUpApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signUpApple;

  /// No description provided for @signUpGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signUpGoogle;

  /// No description provided for @signUpLegalNote.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms & Privacy Policy.'**
  String get signUpLegalNote;

  /// No description provided for @drawerVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get drawerVersion;

  /// No description provided for @profileChooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get profileChooseFromLibrary;

  /// No description provided for @profileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get profileTakePhoto;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileMyProfile;

  /// No description provided for @profileNoProfile.
  ///
  /// In en, this message translates to:
  /// **'No profile'**
  String get profileNoProfile;

  /// No description provided for @profileEditAction.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get profileEditAction;

  /// No description provided for @profileDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'DELETE ACCOUNT'**
  String get profileDeleteAction;

  /// No description provided for @profileDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileDeleteConfirmTitle;

  /// No description provided for @profileDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your profile and data from this device.'**
  String get profileDeleteConfirmBody;

  /// No description provided for @profileDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDelete;

  /// No description provided for @profileSetupProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get profileSetupProfile;

  /// No description provided for @profileSetupTellUsBitAbout.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about you'**
  String get profileSetupTellUsBitAbout;

  /// No description provided for @profileSetupName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileSetupName;

  /// No description provided for @profileSetupContinueKinnav.
  ///
  /// In en, this message translates to:
  /// **'Continue to Kinnav'**
  String get profileSetupContinueKinnav;

  /// No description provided for @profileEditProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileEditProfileUpdated;

  /// No description provided for @profileEditEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditEditProfile;

  /// No description provided for @profileEditMonthYearBirth.
  ///
  /// In en, this message translates to:
  /// **'Month and year of birth'**
  String get profileEditMonthYearBirth;

  /// No description provided for @profileEditSpokenLanguages.
  ///
  /// In en, this message translates to:
  /// **'Spoken languages'**
  String get profileEditSpokenLanguages;

  /// No description provided for @profileEditSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileEditSaveChanges;

  /// No description provided for @chatKinnavSupport.
  ///
  /// In en, this message translates to:
  /// **'Kinnav Support'**
  String get chatKinnavSupport;

  /// No description provided for @chatReplyTime.
  ///
  /// In en, this message translates to:
  /// **'Typically replies in under 5m'**
  String get chatReplyTime;

  /// No description provided for @chatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get chatTypeMessage;

  /// No description provided for @callHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Call History'**
  String get callHistoryTitle;

  /// No description provided for @callHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Safe Calls yet.\nYour past calls with guardians will appear here.'**
  String get callHistoryEmpty;

  /// No description provided for @callHistoryPolice.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get callHistoryPolice;

  /// No description provided for @modulesSelfCare.
  ///
  /// In en, this message translates to:
  /// **'Self Care'**
  String get modulesSelfCare;

  /// No description provided for @moduleDetailLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get moduleDetailLessons;

  /// No description provided for @rewardsRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsRewards;

  /// No description provided for @rewardsGetSafeGetRewarded.
  ///
  /// In en, this message translates to:
  /// **'Get safe. Get rewarded.'**
  String get rewardsGetSafeGetRewarded;

  /// No description provided for @rewardsRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get rewardsRedeemed;

  /// No description provided for @rewardsRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get rewardsRedeem;

  /// No description provided for @guardiansGuardians.
  ///
  /// In en, this message translates to:
  /// **'Guardians'**
  String get guardiansGuardians;

  /// No description provided for @guardiansNearYou.
  ///
  /// In en, this message translates to:
  /// **'Guardians near you'**
  String get guardiansNearYou;

  /// No description provided for @guardiansBecomeGuardian.
  ///
  /// In en, this message translates to:
  /// **'Become a Guardian'**
  String get guardiansBecomeGuardian;

  /// No description provided for @guardiansVerifiedGuardian.
  ///
  /// In en, this message translates to:
  /// **'You are a verified Guardian'**
  String get guardiansVerifiedGuardian;

  /// No description provided for @guardiansAvailableHelp.
  ///
  /// In en, this message translates to:
  /// **'Available to help'**
  String get guardiansAvailableHelp;

  /// No description provided for @guardiansCalls.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get guardiansCalls;

  /// No description provided for @guardiansHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get guardiansHours;

  /// No description provided for @guardiansEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get guardiansEarnings;

  /// No description provided for @guardiansPayoutNote.
  ///
  /// In en, this message translates to:
  /// **'Guardian payouts are processed monthly (Phase 6 — payments).'**
  String get guardiansPayoutNote;

  /// No description provided for @courseGuardianCourse.
  ///
  /// In en, this message translates to:
  /// **'Guardian Course'**
  String get courseGuardianCourse;

  /// No description provided for @courseVerifiedGuardian.
  ///
  /// In en, this message translates to:
  /// **'Verified Guardian'**
  String get courseVerifiedGuardian;

  /// No description provided for @subscriptionActivated.
  ///
  /// In en, this message translates to:
  /// **'Membership active. Welcome! 💜'**
  String get subscriptionActivated;

  /// No description provided for @subscriptionNoPreviousPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found.'**
  String get subscriptionNoPreviousPurchasesFound;

  /// No description provided for @subscriptionKinnavMembership.
  ///
  /// In en, this message translates to:
  /// **'Kinnav Membership'**
  String get subscriptionKinnavMembership;

  /// No description provided for @subscriptionJoinKinnavCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the Kinnav community'**
  String get subscriptionJoinKinnavCommunity;

  /// No description provided for @subscriptionRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get subscriptionRestorePurchases;

  /// No description provided for @subscriptionCancelMembership.
  ///
  /// In en, this message translates to:
  /// **'Cancel membership'**
  String get subscriptionCancelMembership;

  /// No description provided for @subscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get subscriptionActive;

  /// No description provided for @feedbackAddRatingNoteFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a rating or a note first.'**
  String get feedbackAddRatingNoteFirst;

  /// No description provided for @feedbackEmailOpened.
  ///
  /// In en, this message translates to:
  /// **'Your email app is open — press send and we’ll get it.'**
  String get feedbackEmailOpened;

  /// No description provided for @feedbackFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackFeedback;

  /// No description provided for @feedbackHowKinnavExperience.
  ///
  /// In en, this message translates to:
  /// **'How is your Kinnav experience?'**
  String get feedbackHowKinnavExperience;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you love or what we can improve…'**
  String get feedbackHint;

  /// No description provided for @feedbackSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSendFeedback;

  /// No description provided for @howToHowUseKinnav.
  ///
  /// In en, this message translates to:
  /// **'How to use Kinnav'**
  String get howToHowUseKinnav;

  /// No description provided for @aboutAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutAboutUs;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A new way of women safety and empowerment.'**
  String get aboutSubtitle;

  /// No description provided for @aboutSpreadingWord.
  ///
  /// In en, this message translates to:
  /// **'Spreading the word'**
  String get aboutSpreadingWord;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get aboutLegal;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'It\'s easier to look forward when you don\'t have to watch your back.'**
  String get aboutTagline;

  /// No description provided for @aboutTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get aboutTeam;

  /// No description provided for @aboutShivaniFounderSurvivor.
  ///
  /// In en, this message translates to:
  /// **'Shivani — Founder & Survivor'**
  String get aboutShivaniFounderSurvivor;

  /// No description provided for @aboutVishalFullStackEngineer.
  ///
  /// In en, this message translates to:
  /// **'Vishal — Full Stack Engineer'**
  String get aboutVishalFullStackEngineer;

  /// No description provided for @aboutVanshikaMarketingDigitalNative.
  ///
  /// In en, this message translates to:
  /// **'Vanshika — Marketing & Digital Native'**
  String get aboutVanshikaMarketingDigitalNative;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: 2026'**
  String get legalLastUpdated;

  /// No description provided for @coachDismissTip.
  ///
  /// In en, this message translates to:
  /// **'Dismiss tip'**
  String get coachDismissTip;

  /// No description provided for @guardiansBecomeBlurb.
  ///
  /// In en, this message translates to:
  /// **'Vetted women 18+ complete a 40-hour advocacy course, trained virtually by local non-profits. Speak to women in need until they feel safe — no time limit, no judgment. Guardians get paid.'**
  String get guardiansBecomeBlurb;

  /// No description provided for @subscriptionBlurb.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Safe Calls, self-care modules and exclusive wellness rewards.'**
  String get subscriptionBlurb;

  /// No description provided for @subscriptionDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — simulated purchase only. No real charge is made and no App Store / Play billing is used.'**
  String get subscriptionDemoNotice;

  /// No description provided for @aboutMission.
  ///
  /// In en, this message translates to:
  /// **'Kinnav helps women in unsafe situations, anywhere, anytime — connecting them to vetted guardians within a 10-mile radius, and building a community where all women feel free to flourish.'**
  String get aboutMission;

  /// No description provided for @aboutSpreadingBlurb.
  ///
  /// In en, this message translates to:
  /// **'Have questions, suggestions, or just want to let friends and family know we exist? Follow and share us:'**
  String get aboutSpreadingBlurb;

  /// No description provided for @drawerKinnavMember.
  ///
  /// In en, this message translates to:
  /// **'Kinnav member'**
  String get drawerKinnavMember;

  /// No description provided for @drawerGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get drawerGuardian;

  /// No description provided for @drawerCommunityMember.
  ///
  /// In en, this message translates to:
  /// **'Community Member'**
  String get drawerCommunityMember;

  /// No description provided for @drawerInviteFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite a Friend'**
  String get drawerInviteFriend;

  /// No description provided for @drawerInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Join me on Kinnav — a women\'s safety app. https://kinnav.com'**
  String get drawerInviteBody;

  /// No description provided for @drawerSelfCare.
  ///
  /// In en, this message translates to:
  /// **'Self Care & Empowerment'**
  String get drawerSelfCare;

  /// No description provided for @drawerMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get drawerMembership;

  /// No description provided for @drawerContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get drawerContactUs;

  /// No description provided for @drawerContactSubject.
  ///
  /// In en, this message translates to:
  /// **'Kinnav app enquiry'**
  String get drawerContactSubject;

  /// No description provided for @drawerLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get drawerLogOut;
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
