// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Hisnul Muslim';

  @override
  String get shareWithUs => 'Compartilhe o bem';

  @override
  String get shareWithUsSubtitle => 'Compartilhe com um amigo';

  @override
  String get rateApp => 'Avaliar Azkar';

  @override
  String get rateAppSubtitle => 'Deixe uma breve avaliação';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Próximo';

  @override
  String pageCounter(String current, String total) {
    return '$current de $total';
  }

  @override
  String get done => 'Concluído ✓';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get favorites => 'Favoritos';

  @override
  String get allCategories => 'Todas as categorias';

  @override
  String get exitConfirmationTitle => 'Sair da sessão?';

  @override
  String get exitConfirmationBody =>
      'Seu progresso será perdido. Tem certeza que deseja sair?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exit => 'Sair';

  @override
  String get ok => 'OK';

  @override
  String get fontSize => 'Tamanho da fonte';

  @override
  String get sampleText => 'Texto de exemplo';

  @override
  String get language => 'Idioma';

  @override
  String get shareAppSubject =>
      'Azkar — Adhkar da manhã e da tarde, descomplicado';

  @override
  String get shareAppBody =>
      '🤲 Azkar — Adhkar da manhã e da tarde\n\nUm aplicativo gratuito que te ajuda a manter seus adhkar diários do Hisnul Muslim.\n\n✨ Recursos:\n• Adhkar da manhã e da tarde\n• Adhkar ao dormir e ao acordar\n• Contador com um toque\n• Funciona sem conexão\n• Totalmente grátis, sem anúncios\n\nBaixe agora:\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => 'Configurações';

  @override
  String get settingsDisplay => 'Tela';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Modo escuro';

  @override
  String get searchHint => 'Buscar adhkar';

  @override
  String get searchNoResults => 'Nenhum resultado';

  @override
  String get audioPlay => 'Reproduzir recitação';

  @override
  String get audioStop => 'Parar recitação';

  @override
  String get audioDownloadFailed =>
      'Não foi possível carregar o áudio. Verifique sua conexão.';

  @override
  String get onboardingWelcome => 'Bem-vindo ao Azkar';

  @override
  String get onboardingDescription =>
      'Adhkar diários do Hisnul Muslim, no seu idioma.';

  @override
  String get onboardingPickLanguage => 'Escolha seu idioma';

  @override
  String get onboardingTapToCountTitle => 'Toque para contar';

  @override
  String get onboardingTapToCountBody =>
      'Toque o cartão do zikr para avançar o contador. Passa para o próximo automaticamente ao completar.';

  @override
  String get onboardingSwipeTitle => 'Use os botões para navegar';

  @override
  String get onboardingSwipeBody =>
      'Toque em Anterior e Próximo para navegar entre os adhkar de uma categoria.';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String get notificationMorningTitle => 'É hora dos adhkar da manhã';

  @override
  String get notificationMorningBody =>
      'Um instante sereno para começar o dia com os adhkar.';

  @override
  String get notificationEveningTitle => 'É hora dos adhkar da tarde';

  @override
  String get notificationEveningBody =>
      'Um instante sereno para começar a tarde com os adhkar.';

  @override
  String get notificationsScreenTitle => 'Lembretes';

  @override
  String get notificationsScreenIntro =>
      'Lembretes discretos para os adhkar da manhã e da tarde.';

  @override
  String get notificationsMorningLabel => 'Adhkar da manhã';

  @override
  String get notificationsEveningLabel => 'Adhkar da tarde';

  @override
  String get notificationsChannelName => 'Lembretes de adhkar';

  @override
  String get notificationsPermissionDenied =>
      'As notificações estão desativadas nas configurações do seu dispositivo.';

  @override
  String get notificationsPermissionDeniedAction => 'Abrir configurações';

  @override
  String get notificationsBatteryHelperTitle => 'Entrega confiável';

  @override
  String get notificationsBatteryHelperBody =>
      'Permita que o Azkar seja executado em segundo plano para os lembretes chegarem na hora.';

  @override
  String get notificationsBatteryHelperAction =>
      'Permitir atividade em segundo plano';

  @override
  String get notificationsBatteryHelperOemHint =>
      'Em alguns celulares (Xiaomi, Huawei, Samsung), verifique as configurações de economia de bateria se os lembretes ainda falharem.';
}
