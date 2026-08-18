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
}
