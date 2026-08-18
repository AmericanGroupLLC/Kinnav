// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kinnav';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionNext => 'Siguiente';

  @override
  String get actionSkip => 'Omitir';

  @override
  String get actionGetStarted => 'Empezar';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get onboardingWelcomeTitle => 'Te damos la bienvenida a Kinnav';

  @override
  String get onboardingWelcomeBody =>
      'Una nueva forma de seguridad y empoderamiento para las mujeres: ayuda en cualquier lugar y a cualquier hora.';

  @override
  String get onboardingPressTitle => 'Pulsa un botón';

  @override
  String get onboardingPressBody =>
      'Pulsa LLAMAR A GUARDIANAS y elige voz, vídeo, texto o emergencia para conectarte.';

  @override
  String get onboardingGuardiansTitle => 'Las guardianas se quedan contigo';

  @override
  String get onboardingGuardiansBody =>
      'Mujeres verificadas cerca de ti hablan contigo hasta que te sientas segura: sin límite de tiempo y sin juicios.';

  @override
  String get onboardingRewardsTitle => 'Crece y obtén recompensas';

  @override
  String get onboardingRewardsBody =>
      'Módulos de autocuidado y recompensas de bienestar para que florezcas más allá de la seguridad.';

  @override
  String get onboardingDemoMode => 'Modo demo (dev): ir directo a la app';

  @override
  String emergencyConfirmTitle(String number) {
    return '¿Llamar a los servicios de emergencia ($number)?';
  }

  @override
  String get emergencyConfirmBody =>
      'Se realizará una llamada telefónica real a los servicios de emergencia y tus guardianas seguirán en la Llamada Segura.';

  @override
  String emergencyConfirmAction(String number) {
    return 'Llamar al $number';
  }

  @override
  String get safeCallTitle => 'Llamada Segura';

  @override
  String get safeCallConnecting => 'conectando…';

  @override
  String safeCallConnectingTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conectándote con $count guardianas…',
      one: 'Conectándote con 1 guardiana…',
    );
    return '$_temp0';
  }

  @override
  String get safeCallSimulatedBadge =>
      'DEMO · llamada segura simulada (sin vídeo real)';

  @override
  String get safeCallLiveBadge => 'Llamada segura en directo';

  @override
  String get safeCallAddPolice => 'Añadir policía';

  @override
  String get safeCallPoliceAdded => 'Policía añadida';

  @override
  String get safeCallStartVideo => 'Iniciar vídeo';

  @override
  String get safeCallStopVideo => 'Detener vídeo';

  @override
  String get safeCallSpeakerOn => 'Activar altavoz';

  @override
  String get safeCallSpeakerOff => 'Desactivar altavoz';

  @override
  String get safeCallMap => 'Mapa';

  @override
  String get safeCallVideo => 'Vídeo';

  @override
  String get safeCallCoachPolice =>
      'Añade a la policía a la llamada si lo necesitas';

  @override
  String get safeCallCoachToggle => 'Cambia fácilmente entre mapa y vídeo';

  @override
  String get safeCallCoachEnd =>
      '¿Ya estás a salvo? Agradece a tus guardianas y finaliza la llamada';

  @override
  String safeCallNotifyingContacts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Abriendo un mensaje para avisar a tus $count contactos de seguridad…',
      one: 'Abriendo un mensaje para avisar a tu contacto de seguridad…',
    );
    return '$_temp0';
  }

  @override
  String safeCallAlertMessage(String location) {
    return 'Alerta de Kinnav: he iniciado una Llamada Segura y puede que necesite ayuda.$location Por favor, comprueba cómo estoy.';
  }

  @override
  String safeCallAlertLocation(String lat, String lng) {
    return ' Mi ubicación en tiempo real: https://maps.google.com/?q=$lat,$lng.';
  }

  @override
  String get safetyContactsTitle => 'Mis contactos de seguridad';

  @override
  String get safetyContactsBlurb =>
      'Estas personas de confianza reciben tu ubicación en tiempo real cuando inicias una Llamada Segura.';

  @override
  String get safetyContactsEmpty =>
      'Aún no hay contactos. Pulsa Añadir para invitar a alguien.';

  @override
  String get safetyContactsAddTitle => 'Añadir contacto de seguridad';

  @override
  String get safetyContactsName => 'Nombre';

  @override
  String get safetyContactsPhone => 'Teléfono';

  @override
  String get safetyContactsAddAction => 'Añadir contacto';

  @override
  String get safetyContactsNoNumber => 'Sin número';

  @override
  String get safetyContactsRelation => 'Contacto';

  @override
  String get homeMapCallGuardians => 'LLAMAR A GUARDIANAS';

  @override
  String get callOptionsTitle => 'Contacta con una guardiana';

  @override
  String get callOptionsBlurb =>
      'Elige cómo quieres conectarte y luego desliza hacia abajo.';

  @override
  String get callOptionsSlide => 'Desliza';

  @override
  String get callOptionsClose => 'Cerrar';

  @override
  String get signUpTitle => 'Únete a Kinnav';

  @override
  String get signUpSubtitle =>
      'Inicia sesión para conectar con guardianas cerca de ti.';

  @override
  String get signUpAgeConfirm => 'Confirmo que tengo 18 años o más';

  @override
  String get signUpLogIn => 'Iniciar sesión';

  @override
  String get signUpTestAccount => 'Usar cuenta de prueba';

  @override
  String get signUpOr => 'o';

  @override
  String get signUpApple => 'Iniciar sesión con Apple';

  @override
  String get signUpGoogle => 'Continuar con Google';

  @override
  String get signUpLegalNote =>
      'Al continuar aceptas nuestros Términos y la Política de Privacidad.';

  @override
  String get drawerVersion => 'Versión 1.0.1';

  @override
  String get profileChooseFromLibrary => 'Elegir de la galería';

  @override
  String get profileTakePhoto => 'Hacer una foto';

  @override
  String get profileMyProfile => 'Mi perfil';

  @override
  String get profileNoProfile => 'Sin perfil';

  @override
  String get profileEditAction => 'EDITAR PERFIL';

  @override
  String get profileDeleteAction => 'ELIMINAR CUENTA';

  @override
  String get profileDeleteConfirmTitle => '¿Eliminar la cuenta?';

  @override
  String get profileDeleteConfirmBody =>
      'Esto elimina de forma permanente tu perfil y tus datos de este dispositivo.';

  @override
  String get profileDelete => 'Eliminar';

  @override
  String get profileSetupProfile => 'Tu perfil';

  @override
  String get profileSetupTellUsBitAbout => 'Cuéntanos un poco sobre ti';

  @override
  String get profileSetupName => 'Nombre';

  @override
  String get profileSetupContinueKinnav => 'Continuar a Kinnav';

  @override
  String get profileEditProfileUpdated => 'Perfil actualizado.';

  @override
  String get profileEditEditProfile => 'Editar perfil';

  @override
  String get profileEditMonthYearBirth => 'Mes y año de nacimiento';

  @override
  String get profileEditSpokenLanguages => 'Idiomas que hablas';

  @override
  String get profileEditSaveChanges => 'Guardar cambios';

  @override
  String get chatKinnavSupport => 'Soporte de Kinnav';

  @override
  String get chatReplyTime => 'Suele responder en menos de 5 min';

  @override
  String get chatTypeMessage => 'Escribe un mensaje…';

  @override
  String get callHistoryTitle => 'Historial de Llamadas Seguras';

  @override
  String get callHistoryEmpty =>
      'Todavía no hay Llamadas Seguras.\nAquí aparecerán tus llamadas con guardianas.';

  @override
  String get callHistoryPolice => 'Policía';

  @override
  String get modulesSelfCare => 'Autocuidado';

  @override
  String get moduleDetailLessons => 'Lecciones';

  @override
  String get rewardsRewards => 'Recompensas';

  @override
  String get rewardsGetSafeGetRewarded => 'Ponte a salvo. Gana recompensas.';

  @override
  String get rewardsRedeemed => 'Canjeado';

  @override
  String get rewardsRedeem => 'Canjear';

  @override
  String get guardiansGuardians => 'Guardianas';

  @override
  String get guardiansNearYou => 'Guardianas cerca de ti';

  @override
  String get guardiansBecomeGuardian => 'Hazte guardiana';

  @override
  String get guardiansVerifiedGuardian => 'Eres una guardiana verificada';

  @override
  String get guardiansAvailableHelp => 'Disponible para ayudar';

  @override
  String get guardiansCalls => 'Llamadas';

  @override
  String get guardiansHours => 'Horas';

  @override
  String get guardiansEarnings => 'Ingresos';

  @override
  String get guardiansPayoutNote =>
      'Los pagos a las guardianas se procesan mensualmente (Fase 6 — pagos).';

  @override
  String get courseGuardianCourse => 'Curso de guardiana';

  @override
  String get courseVerifiedGuardian => 'Guardiana verificada';

  @override
  String get subscriptionActivated => 'Membresía activa. ¡Bienvenida! 💜';

  @override
  String get subscriptionNoPreviousPurchasesFound =>
      'No se encontraron compras anteriores.';

  @override
  String get subscriptionKinnavMembership => 'Membresía Kinnav';

  @override
  String get subscriptionJoinKinnavCommunity => 'Únete a la comunidad Kinnav';

  @override
  String get subscriptionRestorePurchases => 'Restaurar compras';

  @override
  String get subscriptionCancelMembership => 'Cancelar membresía';

  @override
  String get subscriptionActive => 'ACTIVA';

  @override
  String get feedbackAddRatingNoteFirst =>
      'Añade primero una valoración o un comentario.';

  @override
  String get feedbackEmailOpened =>
      'Tu app de correo está abierta: pulsa enviar y lo recibiremos.';

  @override
  String get feedbackFeedback => 'Comentarios';

  @override
  String get feedbackHowKinnavExperience =>
      '¿Qué tal tu experiencia con Kinnav?';

  @override
  String get feedbackHint => 'Cuéntanos qué te gusta o qué podemos mejorar…';

  @override
  String get feedbackSendFeedback => 'Enviar comentarios';

  @override
  String get howToHowUseKinnav => 'Cómo usar Kinnav';

  @override
  String get aboutAboutUs => 'Sobre nosotras';

  @override
  String get aboutSubtitle =>
      'Una nueva forma de seguridad y empoderamiento para las mujeres.';

  @override
  String get aboutSpreadingWord => 'Corre la voz';

  @override
  String get aboutLegal => 'Legal';

  @override
  String get aboutTagline =>
      'Es más fácil mirar hacia adelante cuando no tienes que cuidarte las espaldas.';

  @override
  String get aboutTeam => 'Nuestro equipo';

  @override
  String get aboutShivaniFounderSurvivor =>
      'Shivani — Fundadora y superviviente';

  @override
  String get aboutVishalFullStackEngineer => 'Vishal — Ingeniero full stack';

  @override
  String get aboutVanshikaMarketingDigitalNative =>
      'Vanshika — Marketing y nativa digital';

  @override
  String get legalLastUpdated => 'Última actualización: 2026';

  @override
  String get coachDismissTip => 'Descartar consejo';

  @override
  String get guardiansBecomeBlurb =>
      'Mujeres verificadas mayores de 18 años completan un curso de defensa de 40 horas, impartido virtualmente por organizaciones locales sin ánimo de lucro. Hablan con mujeres que lo necesitan hasta que se sienten seguras: sin límite de tiempo y sin juicios. Las guardianas reciben pago.';

  @override
  String get subscriptionBlurb =>
      'Llamadas Seguras ilimitadas, módulos de autocuidado y recompensas de bienestar exclusivas.';

  @override
  String get subscriptionDemoNotice =>
      'Modo demo: compra simulada únicamente. No se realiza ningún cargo real ni se usa la facturación de App Store o Play.';

  @override
  String get aboutMission =>
      'Kinnav ayuda a mujeres en situaciones inseguras, en cualquier lugar y momento, conectándolas con guardianas verificadas en un radio de 16 km y creando una comunidad donde todas las mujeres puedan florecer libremente.';

  @override
  String get aboutSpreadingBlurb =>
      '¿Tienes preguntas o sugerencias, o quieres que tus amistades y tu familia nos conozcan? Síguenos y comparte:';

  @override
  String get drawerKinnavMember => 'Miembro de Kinnav';

  @override
  String get drawerGuardian => 'Guardiana';

  @override
  String get drawerCommunityMember => 'Miembro de la comunidad';

  @override
  String get drawerInviteFriend => 'Invitar a una amiga';

  @override
  String get drawerInviteBody =>
      'Únete a mí en Kinnav, una app de seguridad para mujeres. https://kinnav.com';

  @override
  String get drawerSelfCare => 'Autocuidado y empoderamiento';

  @override
  String get drawerMembership => 'Membresía';

  @override
  String get drawerContactUs => 'Contáctanos';

  @override
  String get drawerContactSubject => 'Consulta sobre la app Kinnav';

  @override
  String get drawerLogOut => 'Cerrar sesión';

  @override
  String get signUpAgeRequired => 'Debes confirmar que tienes 18 años o más.';

  @override
  String get signUpOffline =>
      'Sin conexión. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get signUpFailed =>
      'No se pudo iniciar sesión. Comprueba tu conexión y tus credenciales.';

  @override
  String get signUpUnavailable =>
      'El inicio de sesión no está disponible ahora. Inténtalo de nuevo.';
}
