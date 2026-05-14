// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Comparte el bien';

  @override
  String get shareWithUsSubtitle => 'Compártelo con un amigo';

  @override
  String get rateApp => 'Valorar Azkar';

  @override
  String get rateAppSubtitle => 'Deja una breve reseña';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String pageCounter(String current, String total) {
    return '$current de $total';
  }

  @override
  String get done => 'Hecho ✓';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get favorites => 'Favoritos';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get exitConfirmationTitle => '¿Salir de la sesión?';

  @override
  String get exitConfirmationBody =>
      'Se perderá tu progreso. ¿Seguro que quieres salir?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exit => 'Salir';

  @override
  String get ok => 'OK';

  @override
  String get fontSize => 'Tamaño de letra';

  @override
  String get sampleText => 'Texto de ejemplo';

  @override
  String get language => 'Idioma';

  @override
  String get shareAppSubject => 'Azkar — Adhkar de la mañana y la tarde, fácil';

  @override
  String get shareAppBody =>
      '🤲 Azkar — Adhkar de la mañana y la tarde\n\nUna aplicación gratuita que te ayuda a mantener tus adhkar diarios del Hisnul Muslim.\n\n✨ Características:\n• Adhkar de la mañana y la tarde\n• Adhkar al dormir y al despertar\n• Contador con un toque\n• Funciona sin conexión\n• Totalmente gratis, sin anuncios\n\nDescárgala ahora:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Ajustes';

  @override
  String get settingsDisplay => 'Pantalla';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Modo oscuro';

  @override
  String get searchHint => 'Buscar adhkar';

  @override
  String get searchNoResults => 'Sin resultados';

  @override
  String get audioPlay => 'Reproducir recitación';

  @override
  String get audioStop => 'Detener recitación';

  @override
  String get audioDownloadFailed =>
      'No se pudo cargar el audio. Comprueba tu conexión.';

  @override
  String get onboardingWelcome => 'Bienvenido a Azkar';

  @override
  String get onboardingDescription =>
      'Adhkar diarios del Hisnul Muslim, en tu idioma.';

  @override
  String get onboardingPickLanguage => 'Elige tu idioma';

  @override
  String get onboardingTapToCountTitle => 'Toca para contar';

  @override
  String get onboardingTapToCountBody =>
      'Toca la tarjeta del zikr para avanzar el contador. Pasa al siguiente automáticamente al completarse.';

  @override
  String get onboardingSwipeTitle => 'Usa los botones para navegar';

  @override
  String get onboardingSwipeBody =>
      'Toca Anterior y Siguiente para moverte entre los adhkar de una categoría.';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get notificationMorningTitle => 'Es hora de los adhkar de la mañana';

  @override
  String get notificationMorningBody =>
      'Un momento sereno para comenzar el día con los adhkar.';

  @override
  String get notificationEveningTitle => 'Es hora de los adhkar de la tarde';

  @override
  String get notificationEveningBody =>
      'Un momento sereno para comenzar la tarde con los adhkar.';

  @override
  String get notificationsScreenTitle => 'Recordatorios';

  @override
  String get notificationsScreenIntro =>
      'Recordatorios discretos para los adhkar de la mañana y la tarde.';

  @override
  String get notificationsMorningLabel => 'Adhkar de la mañana';

  @override
  String get notificationsEveningLabel => 'Adhkar de la tarde';

  @override
  String get notificationsChannelName => 'Recordatorios de adhkar';

  @override
  String get notificationsPermissionDenied =>
      'Las notificaciones están desactivadas en los ajustes de tu dispositivo.';

  @override
  String get notificationsPermissionDeniedAction => 'Abrir ajustes';

  @override
  String get notificationsBatteryHelperTitle => 'Entrega fiable';

  @override
  String get notificationsBatteryHelperBody =>
      'Permite que Azkar funcione en segundo plano para que los recordatorios lleguen a tiempo.';

  @override
  String get notificationsBatteryHelperAction =>
      'Permitir actividad en segundo plano';

  @override
  String get notificationsBatteryHelperOemHint =>
      'En algunos teléfonos (Xiaomi, Huawei, Samsung), revisa los ajustes de ahorro de batería si los recordatorios fallan.';
}
