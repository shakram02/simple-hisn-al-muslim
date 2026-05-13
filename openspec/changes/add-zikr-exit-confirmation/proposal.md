# Change: Confirm Before Exiting a Zikr Session In Progress

## Why
Per-zikr counters are kept only in memory (`zikrCountMap` in `lib/ui/zikr_category/screen.dart`). Pressing the back button — whether the AppBar arrow, the Android system back, or a gesture-back swipe — pops the route and destroys all progress. Users report losing their place mid-session after an accidental back press. A small confirmation prompt is enough to prevent the loss without nagging users who have nothing to lose.

## What Changes
- Intercept back navigation on the Zikr category detail screen with `PopScope`.
- Show a confirmation dialog **only when there is progress to lose** — at least one zikr in the category has count > 0 AND at least one zikr is not yet fully completed.
- Skip the dialog entirely when the screen is still loading, when the user has not tapped anything, and when every zikr in the category is already fully complete.
- Dialog is Arabic, RTL, with two actions: stay (default) and exit (destructive).

## Impact
- Affected capabilities: `zikr-session` (new — first OpenSpec change in this repo)
- Affected code:
  - `lib/ui/zikr_category/screen.dart` — wrap `Scaffold` in `PopScope`, add progress-check helper, add confirmation dialog
- No new dependencies. No persistence change. No data model change.
