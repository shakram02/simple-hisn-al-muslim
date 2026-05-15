import 'dart:async';

import 'package:azkar/audio/cache.dart';
import 'package:azkar/audio/player.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/arabic_numbers.dart';
import 'package:azkar/ui/drawer/menu.dart';
import 'package:azkar/ui/zikr_category/complete_marker.dart';
import 'package:azkar/ui/zikr_item/audio_bar.dart';
import 'package:azkar/ui/zikr_item/card.dart';
import 'package:azkar/ui/zikr_item/zikr_progress.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ZikrCategoryDetailScreen extends StatefulWidget {
  final ZikrCategory category;
  final int? initialItemId;
  final String localeCode;
  final bool isDarkMode;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final Function(String) onLocaleChanged;
  final VoidCallback onThemeToggle;

  const ZikrCategoryDetailScreen({
    super.key,
    required this.category,
    this.initialItemId,
    required this.localeCode,
    required this.isDarkMode,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.onLocaleChanged,
    required this.onThemeToggle,
  });

  @override
  State<ZikrCategoryDetailScreen> createState() =>
      _ZikrCategoryDetailScreenState();
}

class _ZikrCategoryDetailScreenState extends State<ZikrCategoryDetailScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  double fontSize = 0;
  Map<int, int> zikrCountMap = {};
  List<ZikrItem> categoryItems = [];
  bool isLoading = true;
  Timer? _wakelockTimer;

  // Audio availability state. We hide the audio bar entirely when the
  // user is offline AND the current item's audio file isn't already
  // cached on disk — there's no path to playback in that situation, so
  // showing a dead control is worse than no control.
  bool _hasConnection = true;
  Set<int> _cachedAudioIds = const {};
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadItems();
    _initConnectivityWatch();
    _refreshCachedAudioIds();
    fontSize = widget.fontSize;
    WakelockPlus.enable();
    _wakelockTimer = Timer(const Duration(minutes: 10), () {
      WakelockPlus.disable();
    });
    // When the singleton player successfully starts a new track, that
    // track's file has just been cached. Keep our local set in sync so
    // the bar stays visible if the user later goes offline mid-session.
    ZikrAudioPlayer().playingItemIdNotifier.addListener(_onPlayingChanged);
  }

  Future<void> _initConnectivityWatch() async {
    final connectivity = Connectivity();
    final initial = await connectivity.checkConnectivity();
    if (!mounted) return;
    setState(() => _hasConnection = _hasAnyNetwork(initial));
    _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      if (!mounted) return;
      setState(() => _hasConnection = _hasAnyNetwork(results));
    });
  }

  bool _hasAnyNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  Future<void> _refreshCachedAudioIds() async {
    final ids = await AudioCache().cachedItemIds();
    if (!mounted) return;
    setState(() => _cachedAudioIds = ids);
  }

  void _onPlayingChanged() {
    final id = ZikrAudioPlayer().playingItemIdNotifier.value;
    if (id == null || _cachedAudioIds.contains(id)) return;
    setState(() => _cachedAudioIds = {..._cachedAudioIds, id});
  }

  void _resetWakelockTimer() {
    _wakelockTimer?.cancel();
    WakelockPlus.enable();
    _wakelockTimer = Timer(const Duration(minutes: 10), () {
      WakelockPlus.disable();
    });
  }

  Future<void> _loadItems() async {
    final loaded = await ZikrRepository().loadCategoryItems(
      widget.category.id,
      widget.localeCode,
    );
    if (!mounted) return;
    var jumpToIndex = 0;
    if (widget.initialItemId != null) {
      final idx = loaded.indexWhere((it) => it.id == widget.initialItemId);
      if (idx > 0) jumpToIndex = idx;
    }
    setState(() {
      categoryItems = loaded;
      zikrCountMap = {for (final item in loaded) item.id: 0};
      isLoading = false;
      currentIndex = jumpToIndex;
    });
    if (jumpToIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(jumpToIndex);
        }
      });
    }
  }

  @override
  void dispose() {
    _wakelockTimer?.cancel();
    WakelockPlus.disable();
    ZikrAudioPlayer().playingItemIdNotifier.removeListener(_onPlayingChanged);
    ZikrAudioPlayer().stop();
    _connectivitySub?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  bool _hasUnsavedProgress() {
    if (isLoading || categoryItems.isEmpty) return false;
    var hasAnyProgress = false;
    var allCompleted = true;
    for (final item in categoryItems) {
      final count = zikrCountMap[item.id] ?? 0;
      if (count > 0) hasAnyProgress = true;
      if (count < item.repeatCount) allCompleted = false;
    }
    return hasAnyProgress && !allCompleted;
  }

  Future<bool> _confirmExit() async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exitConfirmationTitle),
        content: Text(l10n.exitConfirmationBody),
        actions: [
          TextButton(
            autofocus: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.exit),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen(title: widget.category.title);
    }

    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final pageLabel = l10n.pageCounter(
      localizedNumber(currentIndex + 1, locale),
      localizedNumber(categoryItems.length, locale),
    );

    return PopScope(
      canPop: !_hasUnsavedProgress(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: ZikrAppBar.getAppBar(
          title: widget.category.title,
          context: context,
        ),
        drawer: AzkarDrawer(
          fontSize: fontSize,
          onFontSizeChanged: (newSize) {
            setState(() {
              fontSize = newSize;
              widget.onFontSizeChanged(newSize);
            });
          },
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
          localeCode: widget.localeCode,
          onLocaleChanged: widget.onLocaleChanged,
        ),
        // Wrap the body in SafeArea (top: false — AppBar handles the
        // status-bar inset) so the audio bar and prev/next buttons at
        // the bottom of the screen aren't clipped under Android 15's
        // edge-to-edge gesture nav.
        body: SafeArea(
          top: false,
          // Listener (not GestureDetector) — observes raw pointer events
          // before the gesture arena resolves them, so it fires even when
          // descendants (ZikrItemCard's onTap, the prev/next TextButtons)
          // win the arena. A GestureDetector here only fires on taps
          // outside any child's hit-test area, which in this screen is
          // effectively never — leaving the wakelock timer pinned to
          // initState and disabling itself after 10 min regardless of how
          // actively the user is counting.
          child: Listener(
            onPointerDown: (_) => _resetWakelockTimer(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _buildItemProgress(),
                ),
                Expanded(child: _buildPageView()),
              if (_currentAudioBarVisible()) ...[
                const SizedBox(height: 8),
                // No item-keyed identity: the same AudioBar element is
                // reused across page changes, keeping its stream
                // subscriptions alive. AudioBar.didUpdateWidget resets
                // any item-specific local state when itemId changes.
                AudioBar(
                  itemId: categoryItems[currentIndex].id,
                  audioUrl: categoryItems[currentIndex].audioUrl!,
                ),
                const SizedBox(height: 4),
              ],
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                // Expanded ends with directional alignment so the prev
                // and next sides each claim equal horizontal flex —
                // leaves the page label in the geometric center of the
                // row regardless of the two buttons' label widths.
                // (spaceBetween only hugs the edges, so the middle item
                // visually drifts toward whichever button is wider.)
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: currentIndex > 0
                              ? () =>
                                    _pageController.jumpToPage(currentIndex - 1)
                              : null,
                          child: Text(
                            l10n.previous,
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(pageLabel),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: currentIndex < categoryItems.length - 1
                              ? () =>
                                    _pageController.jumpToPage(currentIndex + 1)
                              : null,
                          child: Text(
                            l10n.next,
                            style: TextStyle(
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  bool _currentAudioBarVisible() {
    if (categoryItems.isEmpty) return false;
    final item = categoryItems[currentIndex];
    final url = item.audioUrl;
    if (url == null || url.isEmpty) return false;
    // Online → we can download on demand, so show the bar.
    // Offline → only show if the file is already on disk.
    return _hasConnection || _cachedAudioIds.contains(item.id);
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      // Build the immediate neighbors before they enter the viewport so
      // long-markup items (1000+ chars, e.g. Ayat al-Kursi, istikhara)
      // don't pay their first-build layout cost during the slide.
      allowImplicitScrolling: true,
      itemCount: categoryItems.length,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        final zikr = categoryItems[index];
        return ZikrItemCard(
          zikr: zikr,
          localeCode: widget.localeCode,
          fontSize: fontSize,
          currentCount: zikrCountMap[zikr.id] ?? 0,
          onCountChanged: (count) => setState(() {
            zikrCountMap[zikr.id] = count;
          }),
          onCompleted: () {
            // 160ms: short enough to feel snappy after the final tap,
            // long enough for the user to register the "completed"
            // state before the slide starts. 280ms slide: faster than
            // the old 450 but still long enough to read as deliberate.
            Future.delayed(const Duration(milliseconds: 160), () {
              if (!mounted) return;
              if (currentIndex >= categoryItems.length - 1) {
                return;
              }
              _pageController.nextPage(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
              );
              final isNextPageLast = currentIndex == categoryItems.length - 2;
              if (isNextPageLast) {
                _rateApp();
              }
            });
          },
        );
      },
    );
  }

  Widget _buildItemProgress() {
    final current = categoryItems[currentIndex];
    final counter = zikrCountMap[current.id] ?? 0;
    final hasTarget = current.repeatCount > 1;
    final isCompleted = counter == current.repeatCount;

    // Fixed-height slot stabilizes the layout across the three visual
    // states this row can be in:
    //   - in-progress bar:    ZikrProgress (~32 px)
    //   - complete marker:    Row[icon + label] (~22 px)
    //   - no-target spacer:   empty (just reserves the slot)
    //
    // Without a fixed height the slot's intrinsic height varies by
    // ~2–14 px between states (the original code also added a 14-px
    // trailing SizedBox in two of the three branches but not the third,
    // compounding the delta), and the zikr card below shifted on every
    // state transition. 44 px fits the tallest content with breathing
    // room above the card; topCenter alignment keeps the marker /
    // progress bar visually near the AppBar where it sat before.
    const slotHeight = 44.0;

    Widget content;
    if (isCompleted) {
      content = const ZikrItemCompleteMarker();
    } else if (!hasTarget) {
      content = const SizedBox.shrink();
    } else {
      content = ZikrProgress(
        count: counter,
        maxCount: current.repeatCount,
        isCompleted: isCompleted,
        fontSize: fontSize,
      );
    }

    return SizedBox(
      height: slotHeight,
      child: Align(alignment: Alignment.topCenter, child: content),
    );
  }
}

void _rateApp() async {
  final inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  } else {
    inAppReview.openStoreListing();
  }
}
