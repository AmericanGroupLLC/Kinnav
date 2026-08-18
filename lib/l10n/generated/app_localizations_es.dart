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
}
