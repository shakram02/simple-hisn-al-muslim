# Change: App Polish — v1.1 Release

## Why

The app shipped v1.0 with locale-aware content (ar/en/id) and 132 categories.
Day-one usage surfaced four UX gaps and one architectural cleanup that, taken
together, separate "the app translates content" from "the app feels finished":

- **Discovery**: with 132 categories, scrolling is no longer the right primary
  affordance. A search bar at the top of the category list (across all 132 ×
  current-locale items) handles this without taxonomy redesign.
- **Audio**: the catalog already carries an `audio_url` per item; we ship it
  but expose no playback. Adding a tap-to-play with one-time download +
  local cache turns a dormant data field into a daily-use feature.
- **First-run**: users currently drop cold into an Arabic UI even when their
  device locale is `en` or `id`. An onboarding flow (welcome → language →
  brief explainer) sets the right tone before any content is shown.
- **Completion feedback**: tapping a zikr counter to completion currently
  changes the muted "Done ✓" label and auto-advances after 150 ms. The
  reward signal is weak; users have asked for a more tactile success cue.
- **Settings ergonomics**: three icons clutter the AppBar (font / language /
  theme), and the catalog is heading toward more (audio prefs, future
  reminders). A dedicated settings screen replaces the three icons with a
  single gear, with room to grow.

Alongside these features, an editorial audit of the UI strings per locale
(English and Indonesian native-speaker review) closes the gap between
"machine-translated" and "natively-localized" wording.

## What Changes

Five user-visible features plus one editorial pass:

- **Search bar** above the categories list. Queries the existing FTS5
  `item_search` table; supports diacritic-insensitive Arabic, prefix
  matching, multi-locale. Tapping a result opens that item's category
  at the matching item.
- **Audio playback** on each zikr card. Tap-to-play, single-stream (any new
  play stops the prior). First play downloads the audio to app-private
  cache (`<docs>/audio_cache/<item_id>.mp3`); subsequent plays are
  cache hits. Graceful error when offline and not cached.
- **Onboarding** on first launch only: 3 screens (welcome → language picker
  → 30-second explainer of tap-to-count + swipe). Completion is recorded
  in SharedPreferences (`onboardingCompleted=true`) and the flow is
  skipped thereafter.
- **Better completion celebration** for zikr items: brief scale-in + fade
  checkmark animation plus medium-impact haptic on completion, before
  the existing auto-advance kicks in.
- **Settings screen** (`/settings` route). Consolidates font size, locale,
  theme into a single Material list with grouped sections. AppBar's
  three icons collapse into one gear icon. The existing locale-change
  flow (`popUntil(isFirst)` after pick) is preserved.
- **UI strings audit** per locale: review and polish `app_en.arb` and
  `app_id.arb` for natural phrasing. Arabic is canonical, but
  light review to catch typos.

## Impact

- **New capabilities**: `search`, `audio-playback`, `onboarding`, `settings`
- **Modified capabilities**: `zikr-session` (adds completion celebration
  requirement)
- **New dependencies**: `just_audio`, `audio_session`, `path_provider`, `dio`
  (or `http` — pick one in design phase)
- **Affected code**:
  - `lib/main.dart` — onboarding gate before CategoriesScreen
  - `lib/ui/category_list/screen.dart` — search bar at top
  - `lib/ui/zikr_item/card.dart` — audio play button, completion animation
  - `lib/ui/onboarding/` — new directory with 3 screen widgets
  - `lib/ui/settings/screen.dart` — new consolidated settings screen
  - `lib/ui/settings/dialog.dart` — repurpose existing dialog code as the
    settings screen's sub-actions (or delete and inline)
  - `lib/ui/app_bar.dart` — collapse 3 icons to 1 gear
  - `lib/audio/player.dart` — new audio playback service
  - `lib/audio/cache.dart` — new audio cache manager
  - `lib/repo.dart` — add `searchItems(locale, query)` method
  - `lib/ui/settings/settings_pref.dart` — add `onboardingCompleted` key
  - `pubspec.yaml` — new audio deps
  - `lib/l10n/app_{ar,en,id}.arb` — new strings for new features + audit pass
- **Out of scope** (deliberately deferred):
  - State management library (prop drilling is fine at this size)
  - "Offline-only" badging (Play Store concern, not in-app)
  - History/recently-read (deferred to v1.2)
  - Notification reminders (out of scope)
