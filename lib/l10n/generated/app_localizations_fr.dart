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

  @override
  String get signUpTitle => 'Rejoindre Kinnav';

  @override
  String get signUpSubtitle =>
      'Connectez-vous pour joindre les gardiennes près de chez vous.';

  @override
  String get signUpAgeConfirm => 'Je confirme avoir 18 ans ou plus';

  @override
  String get signUpLogIn => 'Se connecter';

  @override
  String get signUpTestAccount => 'Utiliser le compte de test';

  @override
  String get signUpOr => 'ou';

  @override
  String get signUpApple => 'Se connecter avec Apple';

  @override
  String get signUpGoogle => 'Continuer avec Google';

  @override
  String get signUpLegalNote =>
      'En continuant, vous acceptez nos Conditions et notre Politique de confidentialité.';

  @override
  String get drawerVersion => 'Version 1.0.1';

  @override
  String get profileChooseFromLibrary => 'Choisir dans la galerie';

  @override
  String get profileTakePhoto => 'Prendre une photo';

  @override
  String get profileMyProfile => 'Mon profil';

  @override
  String get profileNoProfile => 'Aucun profil';

  @override
  String get profileEditAction => 'MODIFIER LE PROFIL';

  @override
  String get profileDeleteAction => 'SUPPRIMER LE COMPTE';

  @override
  String get profileDeleteConfirmTitle => 'Supprimer le compte ?';

  @override
  String get profileDeleteConfirmBody =>
      'Cela supprime définitivement votre profil et vos données de cet appareil.';

  @override
  String get profileDelete => 'Supprimer';

  @override
  String get profileSetupProfile => 'Votre profil';

  @override
  String get profileSetupTellUsBitAbout => 'Parlez-nous un peu de vous';

  @override
  String get profileSetupName => 'Nom';

  @override
  String get profileSetupContinueKinnav => 'Continuer vers Kinnav';

  @override
  String get profileEditProfileUpdated => 'Profil mis à jour.';

  @override
  String get profileEditEditProfile => 'Modifier le profil';

  @override
  String get profileEditMonthYearBirth => 'Mois et année de naissance';

  @override
  String get profileEditSpokenLanguages => 'Langues parlées';

  @override
  String get profileEditSaveChanges => 'Enregistrer';

  @override
  String get chatKinnavSupport => 'Assistance Kinnav';

  @override
  String get chatReplyTime => 'Répond généralement en moins de 5 min';

  @override
  String get chatTypeMessage => 'Écrivez un message…';

  @override
  String get callHistoryTitle => 'Historique des Appels Sécurisés';

  @override
  String get callHistoryEmpty =>
      'Aucun Appel Sécurisé pour l\'instant.\nVos appels passés avec des gardiennes apparaîtront ici.';

  @override
  String get callHistoryPolice => 'Police';

  @override
  String get modulesSelfCare => 'Bien-être';

  @override
  String get moduleDetailLessons => 'Leçons';

  @override
  String get rewardsRewards => 'Récompenses';

  @override
  String get rewardsGetSafeGetRewarded =>
      'Mettez-vous en sécurité. Soyez récompensée.';

  @override
  String get rewardsRedeemed => 'Utilisée';

  @override
  String get rewardsRedeem => 'Utiliser';

  @override
  String get guardiansGuardians => 'Gardiennes';

  @override
  String get guardiansNearYou => 'Gardiennes près de vous';

  @override
  String get guardiansBecomeGuardian => 'Devenir gardienne';

  @override
  String get guardiansVerifiedGuardian => 'Vous êtes une gardienne vérifiée';

  @override
  String get guardiansAvailableHelp => 'Disponible pour aider';

  @override
  String get guardiansCalls => 'Appels';

  @override
  String get guardiansHours => 'Heures';

  @override
  String get guardiansEarnings => 'Revenus';

  @override
  String get guardiansPayoutNote =>
      'Les paiements des gardiennes sont traités chaque mois (Phase 6 — paiements).';

  @override
  String get courseGuardianCourse => 'Formation de gardienne';

  @override
  String get courseVerifiedGuardian => 'Gardienne vérifiée';

  @override
  String get subscriptionActivated => 'Abonnement actif. Bienvenue ! 💜';

  @override
  String get subscriptionNoPreviousPurchasesFound =>
      'Aucun achat précédent trouvé.';

  @override
  String get subscriptionKinnavMembership => 'Abonnement Kinnav';

  @override
  String get subscriptionJoinKinnavCommunity =>
      'Rejoignez la communauté Kinnav';

  @override
  String get subscriptionRestorePurchases => 'Restaurer les achats';

  @override
  String get subscriptionCancelMembership => 'Résilier l\'abonnement';

  @override
  String get subscriptionActive => 'ACTIF';

  @override
  String get feedbackAddRatingNoteFirst =>
      'Ajoutez d\'abord une note ou un commentaire.';

  @override
  String get feedbackEmailOpened =>
      'Votre application e-mail est ouverte — appuyez sur envoyer et nous le recevrons.';

  @override
  String get feedbackFeedback => 'Commentaires';

  @override
  String get feedbackHowKinnavExperience =>
      'Comment se passe votre expérience Kinnav ?';

  @override
  String get feedbackHint =>
      'Dites-nous ce que vous aimez ou ce que nous pouvons améliorer…';

  @override
  String get feedbackSendFeedback => 'Envoyer';

  @override
  String get howToHowUseKinnav => 'Comment utiliser Kinnav';

  @override
  String get aboutAboutUs => 'À propos';

  @override
  String get aboutSubtitle =>
      'Une nouvelle façon d\'assurer la sécurité et l\'autonomie des femmes.';

  @override
  String get aboutSpreadingWord => 'Faites passer le mot';

  @override
  String get aboutLegal => 'Mentions légales';

  @override
  String get aboutTagline =>
      'Il est plus facile d\'aller de l\'avant quand on n\'a pas à surveiller ses arrières.';

  @override
  String get aboutTeam => 'Notre équipe';

  @override
  String get aboutShivaniFounderSurvivor =>
      'Shivani — Fondatrice et survivante';

  @override
  String get aboutVishalFullStackEngineer => 'Vishal — Ingénieur full stack';

  @override
  String get aboutVanshikaMarketingDigitalNative =>
      'Vanshika — Marketing et native du numérique';

  @override
  String get legalLastUpdated => 'Dernière mise à jour : 2026';

  @override
  String get coachDismissTip => 'Masquer l\'astuce';

  @override
  String get guardiansBecomeBlurb =>
      'Des femmes vérifiées de 18 ans et plus suivent une formation d\'accompagnement de 40 heures, dispensée à distance par des associations locales. Elles parlent aux femmes qui en ont besoin jusqu\'à ce qu\'elles se sentent en sécurité : sans limite de temps ni jugement. Les gardiennes sont rémunérées.';

  @override
  String get subscriptionBlurb =>
      'Appels Sécurisés illimités, modules de bien-être et récompenses exclusives.';

  @override
  String get subscriptionDemoNotice =>
      'Mode démo — achat simulé uniquement. Aucun paiement réel n\'est effectué et aucune facturation App Store ou Play n\'est utilisée.';

  @override
  String get aboutMission =>
      'Kinnav aide les femmes en situation de danger, partout et à tout moment, en les mettant en relation avec des gardiennes vérifiées dans un rayon de 16 km, et en bâtissant une communauté où toutes les femmes peuvent s\'épanouir librement.';

  @override
  String get aboutSpreadingBlurb =>
      'Des questions, des suggestions, ou simplement envie de faire connaître Kinnav à vos proches ? Suivez-nous et partagez :';

  @override
  String get drawerKinnavMember => 'Membre Kinnav';

  @override
  String get drawerGuardian => 'Gardienne';

  @override
  String get drawerCommunityMember => 'Membre de la communauté';

  @override
  String get drawerInviteFriend => 'Inviter une amie';

  @override
  String get drawerInviteBody =>
      'Rejoins-moi sur Kinnav, une application de sécurité pour les femmes. https://kinnav.com';

  @override
  String get drawerSelfCare => 'Bien-être et autonomie';

  @override
  String get drawerMembership => 'Abonnement';

  @override
  String get drawerContactUs => 'Nous contacter';

  @override
  String get drawerContactSubject => 'Demande concernant l\'application Kinnav';

  @override
  String get drawerLogOut => 'Se déconnecter';

  @override
  String get signUpAgeRequired =>
      'Vous devez confirmer que vous avez 18 ans ou plus.';

  @override
  String get signUpOffline =>
      'Pas de connexion. Vérifiez votre réseau et réessayez.';

  @override
  String get signUpFailed =>
      'Connexion impossible. Vérifiez votre réseau et vos identifiants.';

  @override
  String get signUpUnavailable =>
      'Connexion indisponible pour le moment. Veuillez réessayer.';
}
