# Tasks

## 1. Settings screen (foundation for #2)
- [x] 1.1 Create `lib/ui/settings/screen.dart` — new `SettingsScreen` Stateful widget with route `/settings`.
- [x] 1.2 Add sections: Display (font size + theme), Language (current locale tile that opens the locale picker).
- [x] 1.3 Reuse `showFontSizeDialog` and `showLocaleDialog` from list-tile `onTap`s.
- [x] 1.4 Theme toggle becomes a `SwitchListTile` bound to `isDarkMode`.
- [x] 1.5 Add `settings` key to ARB files: title, section headers, sub-titles.
- [x] 1.6 In `lib/ui/app_bar.dart`, replace the three icons (font / globe / brightness) with a single gear icon that pushes `SettingsScreen`.
- [x] 1.7 Wire up gear icon's `onPressed` from `category_list/screen.dart` and `zikr_category/screen.dart` to navigate.
- [x] 1.8 Verify locale-change flow: from settings, pick a new locale → app pops to root and rebuilds with new locale (matches existing v1.0 behavior).

## 2. Onboarding flow
- [x] 2.1 Add `onboardingCompleted` to `SettingsSharedPreferences` (getter + setter).
- [x] 2.2 Create `lib/ui/onboarding/screen.dart` — `OnboardingScreen` with a `PageView` of 3 pages, gesture-back disabled.
- [x] 2.3 Page 1 — Welcome: app name, brief description, "Continue" button.
- [x] 2.4 Page 2 — Language picker: reuses the locale picker widget; "Continue" enabled after a choice.
- [x] 2.5 Page 3 — Quick explainer: "Tap to count" / "Swipe between zikrs"; "Get started" button completes the flow.
- [x] 2.6 Add ARB strings: `onboardingWelcome`, `onboardingDescription`, `onboardingPickLanguage`, `onboardingTapToCount`, `onboardingSwipe`, `onboardingContinue`, `onboardingGetStarted`.
- [x] 2.7 In `lib/main.dart`, gate `home:` on `onboardingCompleted`: show `OnboardingScreen` if false, else `CategoriesScreen`. Use `Navigator.pushReplacement` after onboarding finishes.
- [x] 2.8 Migration safety: in `_initializeApp`, if any pref key exists (e.g. `fontSize`, `firstLaunchAt`) AND `onboardingCompleted` is null, set `onboardingCompleted=true` silently — existing v1.0 users skip onboarding.

## 3. Search bar
- [x] 3.1 Add `searchItems(localeCode, query, {limit})` to `ZikrRepository`. Returns `List<ZikrSearchResult>` (new model).
- [x] 3.2 Define `ZikrSearchResult(itemId, categoryId, categoryTitle, snippet)` in `lib/model.dart`.
- [x] 3.3 Implement the FTS5 query (see design.md) with `MATCH ? || '*'` for prefix and `snippet()` for context.
- [x] 3.4 Add a `TextField` with leading search icon at the top of `category_list/screen.dart`, above the share button.
- [x] 3.5 Debounce input: 250 ms after last keystroke before issuing the query.
- [x] 3.6 Render results in a sublist when the query is non-empty; show categories list when empty.
- [x] 3.7 Empty state when no matches — ARB string `searchNoResults`.
- [x] 3.8 Tap a result → push `ZikrCategoryDetailScreen` with an `initialItemId` parameter; that screen jumps to the matching page on load.
- [x] 3.9 Add `searchHint` ARB string (placeholder for the input).

## 4. Audio playback
- [x] 4.1 Add `just_audio`, `audio_session`, `path_provider`, `http` to `pubspec.yaml` (verify versions compatible with Flutter 3.35).
- [x] 4.2 Create `lib/audio/cache.dart` — `AudioCache` singleton with `Future<File> getOrDownload(int itemId, String url)`.
- [x] 4.3 Create `lib/audio/player.dart` — `ZikrAudioPlayer` singleton wrapping `just_audio`. Single instance, one-stream invariant.
- [x] 4.4 Configure `AudioSession` once at app start (speech category, ducks others).
- [x] 4.5 Add a play/loading/playing icon button to `ZikrItemCard`. State: idle / loading / playing.
- [x] 4.6 On play tap: call `player.play(item)` → `cache.getOrDownload(...)` → `player.setFilePath(...)` → `player.play()`.
- [x] 4.7 On `dispose` of `ZikrCategoryDetailScreen`, call `player.stop()` if a track is playing.
- [x] 4.8 On playback complete, button returns to idle state.
- [x] 4.9 Add ARB strings: `audioPlay`, `audioStop`, `audioDownloadFailed`.
- [x] 4.10 Verify cleartext-traffic: since all audio URLs are now `https://` (post-build), no network-security config change needed.

## 5. Completion celebration
- [x] 5.1 In `lib/ui/zikr_category/complete_marker.dart`, replace the bare `Text` with a `Stack` of `Text` + animated `Icon(Icons.check_circle)` using `AnimatedSwitcher` + `ScaleTransition`.
- [x] 5.2 Curve: `Curves.easeOutBack`, duration 280 ms, opacity fades 0→1.
- [x] 5.3 In `zikr_item/card.dart`'s `_handleTap`, when reaching `repeatCount`, call `HapticFeedback.mediumImpact()` BEFORE invoking `onCompleted`.
- [x] 5.4 In `zikr_category/screen.dart`, change auto-advance delay from 150 ms to 320 ms.
- [x] 5.5 Verify animation doesn't replay on screen re-render for an already-completed item (use `AnimatedSwitcher` with key based on completion state).

## 6. UI strings localization audit
- [ ] 6.1 Review `lib/l10n/app_en.arb` end-to-end. Look for: stilted phrasing, capitalization inconsistencies, jargon that doesn't translate well.
- [ ] 6.2 Review `lib/l10n/app_id.arb` for native-Indonesian phrasing. Avoid ALL-CAPS, prefer "Anda" over "kamu" for the religious context.
- [ ] 6.3 Spot-check `lib/l10n/app_ar.arb` for typos.
- [x] 6.4 Add new strings introduced by features above (search, audio, onboarding, settings) to all three ARB files.
- [x] 6.5 Run `flutter gen-l10n`, verify no key is missing from any locale.

## 7. Verification (manual / device)
- [ ] 7.1 Fresh install on device: onboarding flow appears, language picker works, completion takes you to categories.
- [ ] 7.2 Existing-install upgrade: onboarding is skipped, user continues with their prior preferences.
- [ ] 7.3 Search: type "subhan" (English locale) — results appear, tap one, lands on the matching zikr.
- [ ] 7.4 Search: type "اصبحنا" (Arabic locale, no diacritics) — matches the diacritic-bearing source.
- [ ] 7.5 Search: clear input → categories list returns intact.
- [ ] 7.6 Audio: tap play on cat 27 item 75 — downloads + plays. Tap play on item 76 → 75 stops, 76 plays.
- [ ] 7.7 Audio: enable airplane mode, tap play on a not-yet-cached item — error toast, no crash.
- [ ] 7.8 Audio: navigate back to categories while audio plays — audio stops.
- [ ] 7.9 Completion celebration: do a repeat=3 zikr (e.g., morning adhkar item 76) — see animation + feel haptic on completion.
- [ ] 7.10 Settings: gear icon opens screen; change font size → sliders work; change theme → flips dark; change language → app pops to root in new locale.
- [ ] 7.11 `flutter analyze` clean, `dart format` clean, `flutter build apk --debug` succeeds.

## 8. OpenSpec hygiene
- [x] 8.1 Validate change with `openspec validate add-app-polish-features --strict`.
- [ ] 8.2 After all tasks check off and the v1.1 build ships, archive with `openspec archive add-app-polish-features --yes`.
