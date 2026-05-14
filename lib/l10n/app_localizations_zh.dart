// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '希斯努尔·穆斯林';

  @override
  String get shareWithUs => '传播善行';

  @override
  String get shareWithUsSubtitle => '分享给朋友';

  @override
  String get rateApp => '评价 Azkar';

  @override
  String get rateAppSubtitle => '留下简短评论';

  @override
  String get previous => '上一页';

  @override
  String get next => '下一页';

  @override
  String pageCounter(String current, String total) {
    return '第 $current 项，共 $total 项';
  }

  @override
  String get done => '完成 ✓';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get favorites => '收藏';

  @override
  String get allCategories => '全部分类';

  @override
  String get exitConfirmationTitle => '退出本次诵念？';

  @override
  String get exitConfirmationBody => '您的进度将会丢失，确定要退出吗？';

  @override
  String get cancel => '取消';

  @override
  String get exit => '退出';

  @override
  String get ok => '确定';

  @override
  String get fontSize => '字体大小';

  @override
  String get sampleText => '示例文字';

  @override
  String get language => '语言';

  @override
  String get shareAppSubject => 'Azkar — 简易的晨昏念词';

  @override
  String get shareAppBody =>
      '🤲 Azkar — 简易的晨昏念词\n\n一款免费应用，帮助您坚持《穆斯林堡垒》中的每日念词。\n\n✨ 特点：\n• 晨昏念词\n• 睡前与起身念词\n• 点击计数\n• 离线使用\n• 完全免费，无广告\n\n立即下载：\nhttps://play.google.com/store/apps/details?id=com.github.shakram02.azkar';

  @override
  String get settings => '设置';

  @override
  String get settingsDisplay => '显示';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '深色模式';

  @override
  String get searchHint => '搜索念词';

  @override
  String get searchNoResults => '未找到结果';

  @override
  String get audioPlay => '播放诵念';

  @override
  String get audioStop => '停止诵念';

  @override
  String get audioDownloadFailed => '音频加载失败，请检查您的网络连接。';

  @override
  String get onboardingWelcome => '欢迎使用 Azkar';

  @override
  String get onboardingDescription => '《穆斯林堡垒》中的每日念词，以您的语言呈现。';

  @override
  String get onboardingPickLanguage => '选择您的语言';

  @override
  String get onboardingTapToCountTitle => '点击计数';

  @override
  String get onboardingTapToCountBody => '点击念词卡片以递增计数，完成后会自动跳到下一项。';

  @override
  String get onboardingSwipeTitle => '使用按钮翻页';

  @override
  String get onboardingSwipeBody => '点击「上一页」与「下一页」在同一分类内切换念词。';

  @override
  String get onboardingContinue => '继续';

  @override
  String get onboardingGetStarted => '开始';

  @override
  String get notificationMorningTitle => '晨间念词时间到了';

  @override
  String get notificationMorningBody => '用片刻的宁静以念词开启新的一天。';

  @override
  String get notificationEveningTitle => '晚间念词时间到了';

  @override
  String get notificationEveningBody => '用片刻的宁静以念词开启夜晚。';

  @override
  String get notificationsScreenTitle => '提醒';

  @override
  String get notificationsScreenIntro => '晨晚念词的安静提醒。';

  @override
  String get notificationsMorningLabel => '晨间念词';

  @override
  String get notificationsEveningLabel => '晚间念词';

  @override
  String get notificationsChannelName => 'Azkar 提醒';

  @override
  String get notificationsPermissionDenied => '通知已在设备设置中关闭。';

  @override
  String get notificationsPermissionDeniedAction => '打开设置';

  @override
  String get notificationsBatteryHelperTitle => '可靠送达';

  @override
  String get notificationsBatteryHelperBody => '允许 Azkar 在后台运行，提醒才能准时到达。';

  @override
  String get notificationsBatteryHelperAction => '允许后台活动';

  @override
  String get notificationsBatteryHelperOemHint =>
      '在某些手机（小米、华为、三星）上，如果提醒仍然漏掉，请检查省电设置。';
}
