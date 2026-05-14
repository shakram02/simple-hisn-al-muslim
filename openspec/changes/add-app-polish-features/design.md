# Design Notes — App Polish v1.1

## Context

The app already has localized content (3 locales), a markup-rich render path,
counter UI, exit-confirmation guard, and category favorites in
SharedPreferences. The data layer is stable. This change adds *user-visible*
polish without disturbing those foundations.

Implementation order (each independent unless noted):

1. Settings screen — lays the foundation that onboarding's language picker
   reuses.
2. Onboarding — depends on settings screen patterns.
3. Search bar — fully independent.
4. Audio playback — fully independent.
5. Completion celebration — fully independent, smallest change.
6. UI strings audit — last, after all new strings exist.

## Decisions

### Decision: `just_audio` + `audio_session` + `path_provider` for audio

Use `just_audio` for playback, `audio_session` to declare the audio focus
session, and `path_provider` for cache file paths. Use `http` (already
transitive via in_app_review) to download — no need to add `dio`.

**Rationale**:
- `just_audio` is the de-facto Flutter audio package (Android + iOS + web),
  actively maintained, supports playing from a `File` so it integrates
  cleanly with file-cache.
- `audio_session` is required by `just_audio` to play correctly when the
  app is backgrounded or the device's media buttons are pressed. We
  configure it once on app start.
- `path_provider` gives us `getApplicationSupportDirectory()` which is
  app-private (not visible to other apps, not in iCloud backup) — the
  right place for cache.
- Streaming straight from URL is simpler but disqualifies the "works
  offline after first play" promise. The download-and-cache route is
  worth the modest extra code.

**Alternatives considered**:
- `audioplayers` — older API, more permissive but less robust on iOS
  background playback.
- Direct URL streaming with no cache — fails the offline test.

### Decision: cache audio under `<documents>/audio_cache/<item_id>.mp3`

Path: `getApplicationDocumentsDirectory() + 'audio_cache/' + '<item_id>.mp3'`.
File naming uses the raw item ID, not a hash of the URL, so cache lookups
don't need a URL parse.

**Eviction policy**: none in v1.1. Disk math: ~50 KB per audio × 267 items =
~13 MB worst case if a user listens to every prayer. Acceptable.

**Re-download conditions**:
- File missing (first play)
- File present but zero bytes (failed prior download)
- Otherwise, always serve from cache

If we ever need eviction, add LRU bookkeeping in SharedPreferences keyed by
item_id → last_played_at. Not needed yet.

### Decision: search via FTS5 `item_search` (already in schema)

`build_sqlite.py` creates an FTS5 virtual table over `item_translations`
with `tokenize = 'unicode61 remove_diacritics 2'`. We query with
`MATCH '<term>*'` for prefix matching, scoped to the current locale.

Repository method shape:

```dart
Future<List<ZikrSearchResult>> searchItems(String localeCode, String query, {int limit = 30});
```

Returns `(item_id, category_id, category_title, match_snippet)`. The
category title is joined in so the UI can group results by category if
desired.

**Query**:
```sql
SELECT s.item_id, i.category_id, ct.title AS category_title,
       snippet(item_search, 0, '[', ']', '...', 32) AS match_snippet
FROM item_search s
JOIN items i ON i.id = s.item_id
JOIN category_titles ct
  ON ct.category_id = i.category_id AND ct.locale_code = ?
WHERE s.locale_code = ?
  AND item_search MATCH ? || '*'
LIMIT ?
```

**Rationale**:
- FTS5 is already built into the DB at zero runtime cost.
- `remove_diacritics 2` makes Arabic search work whether or not the user
  types tashkeel — critical for usability.
- `snippet()` is FTS5's built-in highlight, gives us a useful preview
  without extra Dart-side string slicing.

**Alternatives considered**:
- LIKE-based search: case-handling is messy in SQLite, no diacritic
  insensitivity, slower without the FTS index.

### Decision: settings screen replaces, not augments, AppBar dialogs

The settings screen is the new home for font / language / theme. The
existing `showFontSizeDialog`, `showLocaleDialog` and theme-toggle handlers
get called from list-tile taps inside the settings screen.

The locale change flow stays: `setState` in `_ZikrAppState` → save to prefs
→ `popUntil(isFirst)`. This still works from inside the settings screen
because we pop from the *dialog* context (which is inside the settings
screen route).

**Rationale**:
- Single icon, cleaner AppBar, standard Material pattern.
- Room for more settings later (audio prefs, completion-animation
  intensity, etc.) without crowding the AppBar.

**Trade-off**: one extra tap to change language (gear → language → pick).
Worth the cleanup; language change is infrequent in practice.

### Decision: onboarding is a Navigator-rooted flow, not the home

When the app launches and `onboardingCompleted` is false, the home becomes
the onboarding screen instead of CategoriesScreen. After completion, we
set the flag and replace the route with CategoriesScreen via
`Navigator.pushReplacement`.

**Three screens**:
1. Welcome — app icon, name, one-line description, "Continue"
2. Language picker — same `RadioGroup` widget as the settings dialog;
   "Continue" enabled after selection.
3. Quick explainer — illustration + 2 lines: "Tap to count" / "Swipe
   between zikrs". "Get started" finishes onboarding.

Each is a separate StatefulWidget; the parent is a `PageView` with no
swipe back (no `PopScope` complications because there's no progress to
lose during onboarding).

**State persistence**: `SettingsSharedPreferences.saveOnboardingCompleted(true)`
when the user taps "Get started" on screen 3. Language picks during
onboarding go through the same `saveLocale()` path used elsewhere.

### Decision: completion celebration is animation + haptic, not sound

On reaching `repeat_count`, the existing "Done ✓" marker becomes an
animated `Icon(Icons.check_circle)` that scales from 0 → 1.0 with a
gentle bounce curve (`Curves.easeOutBack`) over 280 ms, while also
fading in. Concurrently, `HapticFeedback.mediumImpact()` fires.

Auto-advance delay bumps from 150 ms to 320 ms so the animation can play
without being cut off.

**Rationale**:
- No new dependency (use Flutter's built-in `AnimatedSwitcher` +
  `ScaleTransition`).
- Haptic is universal — works on all phones, no audio focus contention.
- Sound is avoided for now: Islamic apps frequently get used during prayer
  time or in mosques where unexpected sound would be embarrassing.

### Decision: UI strings audit deliverable is the diff against current ARBs

The audit isn't testable via spec scenarios — it's an editorial review.
Acceptance: the final commit shows the updated ARB files, and a brief note
in the commit message recording who reviewed each locale.

Strings to scrutinize specifically:
- Indonesian: avoid ALL-CAPS, prefer modern conversational tone.
- English: "Adhkar" preferred over "Remembrances" (already done in v1.0).
- All locales: error/loading/empty states (we don't have many but they
  should read natively).

## Risks / Trade-offs

### Risk: audio download failures on first play

A user on a flaky network taps play, fetch times out, no audio.

**Mitigation**: 30s timeout on download, single retry with exponential
backoff, clear error UI ("Couldn't download audio. Check your connection.").
The cached path is only written *after* the full file is on disk
successfully — no half-downloaded files left to mislead the next play.

### Risk: cache fills up with audio for casual browsers

A user opens many categories, taps play once each. Worst case 267 ×
~50 KB = 13 MB. Not a real risk yet.

**Mitigation**: defer eviction policy unless real usage data shows it.

### Risk: onboarding pushes existing v1.0 users back through it

Existing users have no `onboardingCompleted` flag set, so they'd see
onboarding on their next launch — surprising and annoying.

**Mitigation**: on first run of v1.1, if any *other* preference key is
present (`fontSize`, `locale`, `firstLaunchAt`), skip onboarding and
silently mark it complete. New installs see it; upgraders don't.

### Risk: settings screen breaks the in-zikr "change language" flow

The current flow: from a zikr detail screen, tap globe icon → pick → pop
to root. Replacing the globe with a gear that opens a screen means the
flow becomes: tap gear → settings screen pushes → pick language → ??

**Mitigation**: when the user changes language *from the settings screen*,
we still `popUntil(isFirst)`. The settings screen pops too, returning the
user to a freshly rebuilt root with the new locale active.

## Migration / Compat

- **v1.0 → v1.1 SharedPreferences**: new keys only (`onboardingCompleted`).
  Existing keys (`fontSize`, `isDarkMode`, `locale`, `favoriteCategoryIds`,
  `firstLaunchAt`, `lastReviewPromptAt`) untouched.
- **SQLite**: no schema changes. v1.1 reads the same `doa_v2.0.sqlite`
  that v1.0 ships.
- **Asset bundle**: adds nothing required. `just_audio` adds platform-side
  natives; APK size grows by ~1–2 MB.

## Open Questions

None — all decisions resolved above.
