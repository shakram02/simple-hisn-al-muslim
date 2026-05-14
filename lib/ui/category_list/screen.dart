import 'dart:async';

import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/loading_screen.dart';
import 'package:azkar/model.dart';
import 'package:azkar/notifications/scheduler.dart';
import 'package:azkar/repo.dart';
import 'package:azkar/ui/app_bar.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/components/soft_card.dart';
import 'package:azkar/ui/components/tinted_card.dart';
import 'package:azkar/ui/drawer/menu.dart';
import 'package:azkar/ui/settings/settings_pref.dart';
import 'package:azkar/ui/zikr_category/screen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class CategoriesScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final double fontSize;
  final Function(double) onFontSizeChanged;
  final String localeCode;
  final Function(String) onLocaleChanged;

  const CategoriesScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.localeCode,
    required this.onLocaleChanged,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<ZikrCategory> favorites = [];
  List<ZikrCategory> nonFavorites = [];
  // null = no search has completed yet for the current query (in-flight
  // or debouncing). empty list = search ran and returned 0 matches.
  // non-empty list = search returned results.
  List<ZikrSearchResult>? searchResults;
  bool isLoading = true;
  String _searchQuery = '';
  Timer? _searchDebounce;

  bool _notificationsBootstrapped = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    pendingTapCategoryId.addListener(_handleNotificationTap);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // First frame inside MaterialApp — AppLocalizations is now in scope.
    // Bootstrap the notification scheduler once per app run: register
    // the channel with a locale-correct name, re-arm any persisted
    // reminder schedules with the current locale's title.
    if (!_notificationsBootstrapped) {
      _notificationsBootstrapped = true;
      _bootstrapNotifications();
    }
  }

  @override
  void dispose() {
    pendingTapCategoryId.removeListener(_handleNotificationTap);
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _bootstrapNotifications() async {
    final l10n = AppLocalizations.of(context);
    await NotificationScheduler.instance.init(
      channelName: l10n.notificationsChannelName,
    );
    if (!mounted) return;
    await NotificationScheduler.instance.reapplyFromPreferences(context);
    // If the app was cold-launched FROM a notification tap, the scheduler
    // pre-populated pendingTapCategoryId during init() — handle it now.
    if (!mounted) return;
    _handleNotificationTap();
  }

  Future<void> _handleNotificationTap() async {
    final id = pendingTapCategoryId.value;
    if (id == null) return;
    pendingTapCategoryId.value = null; // consume
    if (!mounted) return;
    // Pull categories fresh — the in-memory list may not be loaded yet
    // (cold-launch tap arrives before _reload completes).
    final cats = await ZikrRepository().loadCategories(widget.localeCode);
    if (!mounted) return;
    final ZikrCategory target = cats.firstWhere(
      (c) => c.id == id,
      orElse: () => ZikrCategory(id: id, title: '', displayOrder: 0),
    );
    if (target.title.isEmpty) return; // category genuinely not in DB; bail
    if (!mounted) return;
    _openCategory(target);
  }

  Future<void> _initializeApp() async {
    try {
      await _reload();
      _maybeRequestReview();
    } catch (e) {
      debugPrint('Error loading categories: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _reload() async {
    final repo = ZikrRepository();
    final prefs = SettingsSharedPreferences();
    final fromDb = await repo.loadCategories(widget.localeCode);
    final favoriteIds = await prefs.getFavoriteCategoryIds();
    final byId = {for (final c in fromDb) c.id: c};
    final favSet = favoriteIds.toSet();

    final fav = <ZikrCategory>[];
    for (final id in favoriteIds) {
      final c = byId[id];
      if (c != null) fav.add(c.copyWith(isFavorite: true));
    }
    final rest = fromDb.where((c) => !favSet.contains(c.id)).toList();

    if (!mounted) return;
    setState(() {
      favorites = fav;
      nonFavorites = rest;
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite(ZikrCategory category) async {
    final prefs = SettingsSharedPreferences();
    if (category.isFavorite) {
      await prefs.removeFavorite(category.id);
    } else {
      await prefs.addFavorite(category.id);
    }
    if (!mounted) return;
    await _reload();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final trimmed = value.trim();
    // Update _searchQuery INSIDE setState so the UI flips to search-mode
    // immediately on first keystroke. Reset searchResults to null so the
    // user sees a "Searching…" placeholder rather than a stale list of
    // matches for a prior query or a misleading "No results" empty-state.
    setState(() {
      _searchQuery = trimmed;
      searchResults = null;
    });
    if (trimmed.isEmpty) return;
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String query) async {
    if (query != _searchQuery) return;
    final results = await ZikrRepository().searchItems(
      widget.localeCode,
      query,
    );
    if (!mounted || query != _searchQuery) return;
    setState(() => searchResults = results);
  }

  Future<void> _maybeRequestReview() async {
    final prefs = SettingsSharedPreferences();
    final now = DateTime.now();

    final firstLaunchAt = await prefs.getFirstLaunchAt();
    if (firstLaunchAt == null) {
      await prefs.saveFirstLaunchAt(now);
      return;
    }

    if (now.difference(firstLaunchAt) < const Duration(days: 3)) return;

    final lastPromptedAt = await prefs.getLastReviewPromptAt();
    if (lastPromptedAt != null &&
        now.difference(lastPromptedAt) < const Duration(days: 7)) {
      return;
    }

    final inAppReview = InAppReview.instance;
    if (!await inAppReview.isAvailable()) return;

    await inAppReview.requestReview();
    await prefs.saveLastReviewPromptAt(now);
  }

  void _shareApp(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    SharePlus.instance.share(
      ShareParams(subject: l10n.shareAppSubject, text: l10n.shareAppBody),
    );
  }

  Future<void> _rateApp() async {
    // openStoreListing deep-links to the Play Store listing for the
    // installed app. No throttling and no platform availability check
    // needed (unlike requestReview which is opportunistic).
    await InAppReview.instance.openStoreListing();
  }

  void _openCategory(ZikrCategory category, {int? initialItemId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZikrCategoryDetailScreen(
          category: category,
          initialItemId: initialItemId,
          localeCode: widget.localeCode,
          isDarkMode: widget.isDarkMode,
          fontSize: widget.fontSize,
          onFontSizeChanged: widget.onFontSizeChanged,
          onLocaleChanged: widget.onLocaleChanged,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isLoading) {
      return LoadingScreen(title: l10n.appTitle);
    }

    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: ZikrAppBar.getAppBar(title: l10n.appTitle, context: context),
      drawer: AzkarDrawer(
        fontSize: widget.fontSize,
        onFontSizeChanged: widget.onFontSizeChanged,
        isDarkMode: widget.isDarkMode,
        onThemeToggle: widget.onThemeToggle,
        localeCode: widget.localeCode,
        onLocaleChanged: widget.onLocaleChanged,
      ),
      // top: false — the AppBar handles its own top inset. We only
      // need bottom padding so the last category tile / Share+Rate
      // CTA pair isn't clipped by Android 15's edge-to-edge nav-bar.
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _SearchField(hint: l10n.searchHint, onChanged: _onSearchChanged),
            Expanded(
              child: isSearching ? _buildSearchResults(l10n) : _buildList(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(AppLocalizations l10n) {
    final mutedColor = AppColors.of(context).textSecondary;
    final results = searchResults;
    if (results == null) {
      // Search in flight: debouncing or DB query running. A small inline
      // spinner reassures the user something's happening; no full-screen
      // takeover since searches usually return in well under 100ms.
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: mutedColor),
          ),
        ),
      );
    }
    if (results.isEmpty) {
      return Center(
        child: Text(
          l10n.searchNoResults,
          style: TextStyle(color: mutedColor),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final r = results[index];
        return SoftCard(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(
              r.categoryTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              r.snippet,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _openCategoryFromResult(r),
          ),
        );
      },
    );
  }

  Future<void> _openCategoryFromResult(ZikrSearchResult r) async {
    final categories = [...favorites, ...nonFavorites];
    final cat = categories.firstWhere(
      (c) => c.id == r.categoryId,
      orElse: () => ZikrCategory(
        id: r.categoryId,
        title: r.categoryTitle,
        displayOrder: 0,
      ),
    );
    _openCategory(cat, initialItemId: r.itemId);
  }

  Widget _buildList(AppLocalizations l10n) {
    // ListView.builder so only visible items are laid out / painted.
    // Each category tile carries a non-trivial BoxShadow + Material +
    // InkWell, and ListView(children: …) lays out the full 132-item
    // tree eagerly which makes scrolling stutter on lower-end devices.
    final favCount = favorites.length;
    final nonFavCount = nonFavorites.length;
    final hasBothSections = favCount > 0 && nonFavCount > 0;
    // Index layout:
    //   0                                  → CTA pair
    //   1                                  → "Favorites" header (if both sections)
    //   [2 .. 2+favCount-1]                → favorite tiles
    //   2 + favCount                       → "All adhkar" header (if both)
    //   [next .. ]                         → non-favorite tiles
    final favHeader = hasBothSections ? 1 : 0;
    final nonFavHeader = hasBothSections ? 1 : 0;
    final totalCount =
        1 + favHeader + favCount + nonFavHeader + nonFavCount;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _CtaPair(
            onShare: () => _shareApp(context),
            onRate: _rateApp,
          );
        }
        var i = index - 1;
        if (hasBothSections && i == 0) {
          return _SectionHeader(text: l10n.favorites);
        }
        if (hasBothSections) i -= 1;
        if (i < favCount) {
          final c = favorites[i];
          return _CategoryTile(
            key: ValueKey(c.id),
            category: c,
            fontSize: widget.fontSize,
            onToggleFavorite: () => _toggleFavorite(c),
            onTap: () => _openCategory(c),
          );
        }
        i -= favCount;
        if (hasBothSections && i == 0) {
          return _SectionHeader(text: l10n.allCategories);
        }
        if (hasBothSections) i -= 1;
        final c = nonFavorites[i];
        return _CategoryTile(
          key: ValueKey(c.id),
          category: c,
          fontSize: widget.fontSize,
          onToggleFavorite: () => _toggleFavorite(c),
          onTap: () => _openCategory(c),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Building blocks

/// Pill-shaped search field that sits between the AppBar and the
/// scrolling list. White card surface, soft shadow, no border.
class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SoftCard(
        child: TextField(
          // Search is a secondary affordance for this app — users
          // primarily browse by category. Don't grab focus on screen
          // build so the keyboard doesn't pop up on every launch.
          autofocus: false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: AppColors.of(context).iconMuted,
            ),
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 14,
            ),
          ),
          // titleSmall feels right for a TextField — same weight/size
          // as the row labels users browse.
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Share + Rate side-by-side mini-cards at the top of the scrolling
/// list. Different surface tints (teal / gold) signal that these are
/// "support the app" affordances, not category items.
class _CtaPair extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onRate;

  const _CtaPair({required this.onShare, required this.onRate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: _CtaCard(
              title: l10n.shareWithUs,
              subtitle: l10n.shareWithUsSubtitle,
              icon: Icons.ios_share_rounded,
              accent: AppTheme.primaryColor.shade500,
              tint: AppTheme.primaryColor.shade500.withValues(alpha: 0.10),
              onTap: onShare,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CtaCard(
              title: l10n.rateApp,
              subtitle: l10n.rateAppSubtitle,
              icon: Icons.star_rounded,
              accent: AppTheme.secondaryColor.shade500,
              tint: AppTheme.secondaryColor.shade500.withValues(alpha: 0.14),
              onTap: onRate,
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color tint;
  final VoidCallback onTap;

  const _CtaCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return TintedCard(
      tint: tint,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // bodyMedium with bold weight — the CTA pair runs
                  // at compact width, so a slightly smaller title than
                  // the category rows keeps the double-line layout
                  // balanced.
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        height: 1.3,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 8),
      child: Text(
        text,
        // Section headers use Vazirmatn at small caps treatment —
        // bodySmall with extended tracking + heavy weight for the
        // "FAVORITES" / "ALL" labels.
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: AppTheme.displayFontFamily,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.of(context).textSecondary,
            ),
      ),
    );
  }
}

/// Card surface with rounded corners + soft shadow, no border.
/// Reused for category tiles and search-result tiles.
class _CategoryTile extends StatelessWidget {
  final ZikrCategory category;
  final double fontSize;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _CategoryTile({
    super.key,
    required this.category,
    required this.fontSize,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final titleColor = colors.textPrimary;
    final inactiveHeartColor = colors.iconMuted;
    return SoftCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              category.title,
              style: TextStyle(
                fontSize: fontSize - 5, // 15 at default 20 base
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: -0.1,
                color: titleColor,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 20,
            tooltip: category.isFavorite
                ? l10n.removeFromFavorites
                : l10n.addToFavorites,
            icon: Icon(
              category.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: category.isFavorite
                  ? AppTheme.favoriteColor
                  : inactiveHeartColor,
            ),
            onPressed: onToggleFavorite,
          ),
        ],
      ),
    );
  }
}
