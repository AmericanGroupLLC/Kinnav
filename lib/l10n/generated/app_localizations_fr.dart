// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionNext => 'Suivant';

  @override
  String get actionSkip => 'Passer';

  @override
  String get actionGetStarted => 'Commencer';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Kinnav';

  @override
  String get onboardingWelcomeBody =>
      'Une nouvelle façon d\'assurer la sécurité et l\'autonomie des femmes : de l\'aide, partout et à tout moment.';

  @override
  String get onboardingPressTitle => 'Appuyez sur un bouton';

  @override
  String get onboardingPressBody =>
      'Appuyez sur APPELER DES GARDIENNES et choisissez appel vocal, vidéo, message ou urgence pour vous connecter.';

  @override
  String get onboardingGuardiansTitle => 'Les gardiennes restent avec vous';

  @override
  String get onboardingGuardiansBody =>
      'Des femmes vérifiées près de chez vous vous parlent jusqu\'à ce que vous vous sentiez en sécurité : sans limite de temps ni jugement.';

  @override
  String get onboardingRewardsTitle => 'Progressez et soyez récompensée';

  @override
  String get onboardingRewardsBody =>
      'Des modules de bien-être et des récompenses pour vous épanouir au-delà de la sécurité.';

  @override
  String get onboardingDemoMode =>
      'Mode démo (dev) — accéder directement à l\'app';

  @override
  String emergencyConfirmTitle(String number) {
    return 'Appeler les services d\'urgence ($number) ?';
  }

  @override
  String get emergencyConfirmBody =>
      'Un véritable appel téléphonique sera passé aux services d\'urgence et vos gardiennes resteront dans l\'Appel Sécurisé.';

  @override
  String emergencyConfirmAction(String number) {
    return 'Appeler le $number';
  }

  @override
  String get safeCallTitle => 'Appel Sécurisé';

  @override
  String get safeCallConnecting => 'connexion…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connexion avec $count gardiennes…',
      one: 'Connexion avec 1 gardienne…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge =>
      'DÉMO · appel sécurisé simulé (pas de vidéo réelle)';

  @override
  String get safeCallLiveBadge => 'Appel sécurisé en direct';

  @override
  String get safeCallAddPolice => 'Ajouter la police';

  @override
  String get safeCallPoliceAdded => 'Police ajoutée';

  @override
  String get safeCallStartVideo => 'Activer la vidéo';

  @override
  String get safeCallStopVideo => 'Arrêter la vidéo';

  @override
  String get safeCallSpeakerOn => 'Activer le haut-parleur';

  @override
  String get safeCallSpeakerOff => 'Couper le haut-parleur';

  @override
  String get safeCallMap => 'Carte';

  @override
  String get safeCallVideo => 'Vidéo';

  @override
  String get safeCallCoachPolice =>
      'Ajoutez la police à l\'appel si nécessaire';

  @override
  String get safeCallCoachToggle =>
      'Basculez simplement entre la carte et la vidéo';

  @override
  String get safeCallCoachEnd =>
      'De retour en sécurité ? Remerciez vos gardiennes et terminez l\'appel';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ouverture d\'un message pour prévenir vos $count contacts de sécurité…',
      one: 'Ouverture d\'un message pour prévenir votre contact de sécurité…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'Alerte Kinnav : j\'ai lancé un Appel Sécurisé et j\'ai peut-être besoin d\'aide.$location Merci de prendre de mes nouvelles.';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' Ma position en temps réel : https://maps.google.com/?q=$lat,$lng.';
  }

  @override
  String get safetyContactsTitle => 'Mes contacts de sécurité';

  @override
  String get safetyContactsBlurb =>
      'Ces personnes de confiance reçoivent votre position en temps réel lorsque vous lancez un Appel Sécurisé.';

  @override
  String get safetyContactsEmpty =>
      'Aucun contact pour l\'instant. Appuyez sur Ajouter pour inviter quelqu\'un.';

  @override
  String get safetyContactsAddTitle => 'Ajouter un contact de sécurité';

  @override
  String get safetyContactsName => 'Nom';

  @override
  String get safetyContactsPhone => 'Téléphone';

  @override
  String get safetyContactsAddAction => 'Ajouter le contact';

  @override
  String get safetyContactsNoNumber => 'Pas de numéro';

  @override
  String get safetyContactsRelation => 'Contact';

  @override
  String get homeMapCallGuardians => 'APPELER DES GARDIENNES';

  @override
  String get callOptionsTitle => 'Contacter une gardienne';

  @override
  String get callOptionsBlurb =>
      'Choisissez comment vous connecter, puis faites glisser vers le bas.';

  @override
  String get callOptionsSlide => 'Faites glisser';

  @override
  String get callOptionsClose => 'Fermer';
}
