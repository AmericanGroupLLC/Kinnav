// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionNext => 'Next';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionGetStarted => 'Get Started';

  @override
  String get actionAdd => 'Add';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Kinnav';

  @override
  String get onboardingWelcomeBody =>
      'A new way of women safety and empowerment — help, anywhere, anytime.';

  @override
  String get onboardingPressTitle => 'Press a button';

  @override
  String get onboardingPressBody =>
      'Tap CALL GUARDIANS and choose voice, video, text or emergency to connect.';

  @override
  String get onboardingGuardiansTitle => 'Guardians stay with you';

  @override
  String get onboardingGuardiansBody =>
      'Vetted women nearby talk to you until you feel safe — no time limit, no judgment.';

  @override
  String get onboardingRewardsTitle => 'Grow & get rewarded';

  @override
  String get onboardingRewardsBody =>
      'Self-care modules and wellness rewards to help you flourish beyond safety.';

  @override
  String get onboardingDemoMode => 'Demo mode (dev) — skip to app';

  @override
  String emergencyConfirmTitle(String number) {
    return 'Call emergency services ($number)?';
  }

  @override
  String get emergencyConfirmBody =>
      'This will place a real phone call to emergency services and keep your guardians on the Safe Call.';

  @override
  String emergencyConfirmAction(String number) {
    return 'Call $number';
  }

  @override
  String get safeCallTitle => 'Safe Call';

  @override
  String get safeCallConnecting => 'connecting…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connecting you to $count guardians…',
      one: 'Connecting you to 1 guardian…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge =>
      'DEMO · simulated safe call (no live video)';

  @override
  String get safeCallLiveBadge => 'Live safe call';

  @override
  String get safeCallAddPolice => 'Add police';

  @override
  String get safeCallPoliceAdded => 'Police added';

  @override
  String get safeCallStartVideo => 'Start Video';

  @override
  String get safeCallStopVideo => 'Stop Video';

  @override
  String get safeCallSpeakerOn => 'Turn On Speaker';

  @override
  String get safeCallSpeakerOff => 'Turn Off Speaker';

  @override
  String get safeCallMap => 'Map';

  @override
  String get safeCallVideo => 'Video';

  @override
  String get safeCallCoachPolice => 'Add the police to the call, if needed';

  @override
  String get safeCallCoachToggle => 'Simply switch between map and video';

  @override
  String get safeCallCoachEnd =>
      'Back to safety? Thank your guardians and end the call';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Opening a text to notify your $count safety contacts…',
      one: 'Opening a text to notify your 1 safety contact…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'Kinnav alert: I\'ve started a Safe Call and may need help.$location Please check on me.';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' My live location: https://maps.google.com/?q=$lat,$lng.';
  }

  @override
  String get safetyContactsTitle => 'My Safety Contacts';

  @override
  String get safetyContactsBlurb =>
      'These trusted people are notified with your live location when you start a Safe Call.';

  @override
  String get safetyContactsEmpty =>
      'No contacts yet. Tap Add to invite someone.';

  @override
  String get safetyContactsAddTitle => 'Add safety contact';

  @override
  String get safetyContactsName => 'Name';

  @override
  String get safetyContactsPhone => 'Phone';

  @override
  String get safetyContactsAddAction => 'Add contact';

  @override
  String get safetyContactsNoNumber => 'No number';

  @override
  String get safetyContactsRelation => 'Contact';

  @override
  String get homeMapCallGuardians => 'CALL GUARDIANS';

  @override
  String get callOptionsTitle => 'Reach a Guardian';

  @override
  String get callOptionsBlurb =>
      'Choose how you want to connect, then slide down.';

  @override
  String get callOptionsSlide => 'Slide Down';

  @override
  String get callOptionsClose => 'Close';

  @override
  String get signUpTitle => 'Join Kinnav';

  @override
  String get signUpSubtitle => 'Sign in to connect with guardians near you.';

  @override
  String get signUpAgeConfirm => 'I confirm I am 18 years or older';

  @override
  String get signUpLogIn => 'Log in';

  @override
  String get signUpTestAccount => 'Use test account';

  @override
  String get signUpOr => 'or';

  @override
  String get signUpApple => 'Sign in with Apple';

  @override
  String get signUpGoogle => 'Continue with Google';

  @override
  String get signUpLegalNote =>
      'By continuing you agree to our Terms & Privacy Policy.';

  @override
  String get drawerVersion => 'Version 1.0.1';

  @override
  String get profileChooseFromLibrary => 'Choose from library';

  @override
  String get profileTakePhoto => 'Take a photo';

  @override
  String get profileMyProfile => 'My Profile';

  @override
  String get profileNoProfile => 'No profile';

  @override
  String get profileEditAction => 'EDIT PROFILE';

  @override
  String get profileDeleteAction => 'DELETE ACCOUNT';

  @override
  String get profileDeleteConfirmTitle => 'Delete account?';

  @override
  String get profileDeleteConfirmBody =>
      'This permanently removes your profile and data from this device.';

  @override
  String get profileDelete => 'Delete';

  @override
  String get profileSetupProfile => 'Your Profile';

  @override
  String get profileSetupTellUsBitAbout => 'Tell us a bit about you';

  @override
  String get profileSetupName => 'Name';

  @override
  String get profileSetupContinueKinnav => 'Continue to Kinnav';

  @override
  String get profileEditProfileUpdated => 'Profile updated.';

  @override
  String get profileEditEditProfile => 'Edit Profile';

  @override
  String get profileEditMonthYearBirth => 'Month and year of birth';

  @override
  String get profileEditSpokenLanguages => 'Spoken languages';

  @override
  String get profileEditSaveChanges => 'Save changes';

  @override
  String get chatKinnavSupport => 'Kinnav Support';

  @override
  String get chatReplyTime => 'Typically replies in under 5m';

  @override
  String get chatTypeMessage => 'Type a message…';

  @override
  String get callHistoryTitle => 'Safe Call History';

  @override
  String get callHistoryEmpty =>
      'No Safe Calls yet.\nYour past calls with guardians will appear here.';

  @override
  String get callHistoryPolice => 'Police';

  @override
  String get modulesSelfCare => 'Self Care';

  @override
  String get moduleDetailLessons => 'Lessons';

  @override
  String get rewardsRewards => 'Rewards';

  @override
  String get rewardsGetSafeGetRewarded => 'Get safe. Get rewarded.';

  @override
  String get rewardsRedeemed => 'Redeemed';

  @override
  String get rewardsRedeem => 'Redeem';

  @override
  String get guardiansGuardians => 'Guardians';

  @override
  String get guardiansNearYou => 'Guardians near you';

  @override
  String get guardiansBecomeGuardian => 'Become a Guardian';

  @override
  String get guardiansVerifiedGuardian => 'You are a verified Guardian';

  @override
  String get guardiansAvailableHelp => 'Available to help';

  @override
  String get guardiansCalls => 'Calls';

  @override
  String get guardiansHours => 'Hours';

  @override
  String get guardiansEarnings => 'Earnings';

  @override
  String get guardiansPayoutNote =>
      'Guardian payouts are processed monthly (Phase 6 — payments).';

  @override
  String get courseGuardianCourse => 'Guardian Course';

  @override
  String get courseVerifiedGuardian => 'Verified Guardian';

  @override
  String get subscriptionActivated => 'Membership active. Welcome! 💜';

  @override
  String get subscriptionNoPreviousPurchasesFound =>
      'No previous purchases found.';

  @override
  String get subscriptionKinnavMembership => 'Kinnav Membership';

  @override
  String get subscriptionJoinKinnavCommunity => 'Join the Kinnav community';

  @override
  String get subscriptionRestorePurchases => 'Restore purchases';

  @override
  String get subscriptionCancelMembership => 'Cancel membership';

  @override
  String get subscriptionActive => 'ACTIVE';

  @override
  String get feedbackAddRatingNoteFirst => 'Add a rating or a note first.';

  @override
  String get feedbackEmailOpened =>
      'Your email app is open — press send and we’ll get it.';

  @override
  String get feedbackFeedback => 'Feedback';

  @override
  String get feedbackHowKinnavExperience => 'How is your Kinnav experience?';

  @override
  String get feedbackHint => 'Tell us what you love or what we can improve…';

  @override
  String get feedbackSendFeedback => 'Send feedback';

  @override
  String get howToHowUseKinnav => 'How to use Kinnav';

  @override
  String get aboutAboutUs => 'About Us';

  @override
  String get aboutSubtitle => 'A new way of women safety and empowerment.';

  @override
  String get aboutSpreadingWord => 'Spreading the word';

  @override
  String get aboutLegal => 'Legal';

  @override
  String get aboutTagline =>
      'It\'s easier to look forward when you don\'t have to watch your back.';

  @override
  String get aboutTeam => 'Our Team';

  @override
  String get aboutShivaniFounderSurvivor => 'Shivani — Founder & Survivor';

  @override
  String get aboutVishalFullStackEngineer => 'Vishal — Full Stack Engineer';

  @override
  String get aboutVanshikaMarketingDigitalNative =>
      'Vanshika — Marketing & Digital Native';

  @override
  String get legalLastUpdated => 'Last updated: 2026';

  @override
  String get coachDismissTip => 'Dismiss tip';

  @override
  String get guardiansBecomeBlurb =>
      'Vetted women 18+ complete a 40-hour advocacy course, trained virtually by local non-profits. Speak to women in need until they feel safe — no time limit, no judgment. Guardians get paid.';

  @override
  String get subscriptionBlurb =>
      'Unlimited Safe Calls, self-care modules and exclusive wellness rewards.';

  @override
  String get subscriptionDemoNotice =>
      'Demo mode — simulated purchase only. No real charge is made and no App Store / Play billing is used.';

  @override
  String get aboutMission =>
      'Kinnav helps women in unsafe situations, anywhere, anytime — connecting them to vetted guardians within a 10-mile radius, and building a community where all women feel free to flourish.';

  @override
  String get aboutSpreadingBlurb =>
      'Have questions, suggestions, or just want to let friends and family know we exist? Follow and share us:';

  @override
  String get drawerKinnavMember => 'Kinnav member';

  @override
  String get drawerGuardian => 'Guardian';

  @override
  String get drawerCommunityMember => 'Community Member';

  @override
  String get drawerInviteFriend => 'Invite a Friend';

  @override
  String get drawerInviteBody =>
      'Join me on Kinnav — a women\'s safety app. https://kinnav.com';

  @override
  String get drawerSelfCare => 'Self Care & Empowerment';

  @override
  String get drawerMembership => 'Membership';

  @override
  String get drawerContactUs => 'Contact Us';

  @override
  String get drawerContactSubject => 'Kinnav app enquiry';

  @override
  String get drawerLogOut => 'Log out';

  @override
  String get signUpAgeRequired => 'You must confirm you are 18 or older.';

  @override
  String get signUpOffline =>
      'No connection. Check your network and try again.';

  @override
  String get signUpFailed =>
      'Could not sign in. Check your connection and credentials.';

  @override
  String get signUpUnavailable =>
      'Sign-in unavailable right now. Please try again.';
}
