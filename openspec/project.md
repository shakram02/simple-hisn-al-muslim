# Azkar — Project Conventions

Flutter app for reading and counting *azkar* (Islamic remembrances). The user opens a category (morning azkar, evening azkar, after-prayer, etc.), the app loads its zikr items from a bundled SQLite DB, and the user taps through them — each item has a target count and a per-session counter.

## Tech

- **Flutter** (Dart). Material widgets, RTL throughout.
- **SQLite** (bundled assets `doa_v1.0.sqlite`, `doa_localized_v1.1.sqlite`) accessed via the repository in `lib/repo.dart`.
- **State**: per-screen `StatefulWidget` with `setState`. No state-management library.
- **Persistence**: only user preferences (theme, font size). Per-session zikr counters are deliberately ephemeral.

## Conventions

- UI strings are in Arabic. Numerals shown to the user go through `arabicNumber()` (`lib/ui/arabic_numbers.dart`).
- Screens live under `lib/ui/<feature>/screen.dart`. Shared widgets sit beside the screen or under `lib/ui/`.
- Prefer the modern `PopScope` API for intercepting back navigation. `WillPopScope` is deprecated.
- No comments unless the *why* is non-obvious. Identifiers and code should speak for themselves.
- Keep features small and self-contained — this app's value is calm simplicity, not architectural sophistication.

## Capabilities

Capabilities are tracked under `openspec/specs/<capability>/spec.md`. Current capabilities:

- **zikr-session** — the user's in-progress reading of a category's azkar (counters, navigation, exit handling).
