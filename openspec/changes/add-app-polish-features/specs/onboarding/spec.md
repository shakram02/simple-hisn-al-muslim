# Onboarding — Spec Delta

## ADDED Requirements

### Requirement: First-launch onboarding for new installations
The app SHALL show a 3-step onboarding flow as the root route on first launch — when no previous user preferences are detected — before the main content is reachable. The flow SHALL allow the user to pick their preferred language
and SHALL briefly explain the core interactions.

The flow SHALL NOT be shown to users upgrading from an earlier version
who have any existing preference values stored.

After the flow is completed, a persistent flag SHALL prevent it from
ever appearing again for that user on that device.

#### Scenario: True first launch shows onboarding
- **GIVEN** the app has never been launched on this device
- **AND** no SharedPreferences keys are present
- **WHEN** the app starts
- **THEN** the onboarding flow is shown as the root route
- **AND** the categories screen is not visible

#### Scenario: Existing v1.0 users skip onboarding
- **GIVEN** the app has been launched previously (at least one preference key exists)
- **AND** `onboardingCompleted` has not been explicitly set
- **WHEN** the app starts under v1.1 for the first time
- **THEN** the onboarding flow is NOT shown
- **AND** `onboardingCompleted` is silently set to `true`
- **AND** the categories screen is the root route

#### Scenario: Welcome screen
- **GIVEN** onboarding has begun
- **WHEN** the user lands on screen 1
- **THEN** the screen shows the app name and a one-line description
- **AND** a "Continue" button advances to screen 2

#### Scenario: Language picker during onboarding
- **GIVEN** the user is on screen 2 (language picker)
- **WHEN** the user picks a locale from the available options
- **THEN** the choice is saved via the standard locale-save flow
- **AND** "Continue" advances to screen 3
- **AND** the rest of the onboarding flow renders in the chosen locale

#### Scenario: Quick explainer
- **GIVEN** the user is on screen 3
- **THEN** the screen shows two short hints in the chosen locale:
    "Tap to count" and "Swipe between zikrs"
- **AND** a "Get started" button finishes the flow

#### Scenario: Finishing onboarding
- **WHEN** the user taps "Get started" on screen 3
- **THEN** `onboardingCompleted` is set to `true`
- **AND** the categories screen replaces the onboarding flow
- **AND** the user cannot navigate back into onboarding

#### Scenario: Subsequent launches skip onboarding
- **GIVEN** `onboardingCompleted` is `true`
- **WHEN** the app starts
- **THEN** the categories screen is the root route
- **AND** no onboarding flow is shown
