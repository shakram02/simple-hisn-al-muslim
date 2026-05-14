# Settings — Spec Delta

## ADDED Requirements

### Requirement: Drawer + settings screen architecture
The app SHALL expose a left-side navigation drawer on every primary screen — opened via the standard hamburger affordance — containing inline quick-action controls plus an entry to a dedicated settings screen for less-frequent preferences.

The drawer SHALL include:
- a header with the app name,
- a theme toggle (light / dark) as an inline `SwitchListTile`,
- a font-size slider as an inline quick action,
- a "Settings" tile that pushes the dedicated `SettingsScreen`.

The dedicated settings screen SHALL group less-frequent preferences (language now; future audio/notification options) into clear sections.

The three AppBar icons used in v1.0 (font size, language, theme toggle) SHALL be replaced — theme and font become inline drawer actions; language lives on the settings screen behind a tile that opens the existing locale picker dialog.

Changes made via the drawer or settings screen SHALL apply immediately and persist across launches. When the user changes locale, the app SHALL return to the root route so any deeper screens are rebuilt with the new locale (same flow as v1.0).

#### Scenario: Opening the drawer
- **GIVEN** the user is on any primary screen
- **WHEN** the user taps the hamburger icon (or swipes from the leading edge)
- **THEN** the drawer slides in from the leading edge
- **AND** the header, theme toggle, font slider, and Settings tile are visible

#### Scenario: Theme toggle from the drawer
- **WHEN** the user taps the theme switch
- **THEN** the app switches between light and dark mode immediately
- **AND** the choice persists across launches

#### Scenario: Font size slider from the drawer
- **WHEN** the user drags the font-size slider
- **THEN** the displayed value updates live as the slider moves
- **AND** on release, the new size is applied and persisted

#### Scenario: Opening the settings screen
- **GIVEN** the drawer is open
- **WHEN** the user taps "Settings"
- **THEN** the drawer closes
- **AND** the settings screen is pushed onto the navigation stack
- **AND** the screen title reads "Settings" in the active locale

#### Scenario: Changing language from the settings screen
- **WHEN** the user taps the language tile, picks a different locale, and confirms
- **THEN** the choice is persisted
- **AND** the app pops back to the root route
- **AND** the root rebuilds with the new locale applied

#### Scenario: Closing the drawer / settings
- **WHEN** the user taps outside the drawer (or the system back affordance on the settings screen)
- **THEN** the drawer or screen closes
- **AND** the user returns to the screen they were on before opening it
- **AND** any setting changes made during this session are still in effect
