# Zikr Session — Spec Delta

## ADDED Requirements

### Requirement: Tactile celebration on reaching a zikr's repeat count
The app SHALL signal completion with a brief animated checkmark and a haptic pulse when the user reaches a zikr's `repeat_count`, before the existing auto-advance to the next zikr fires.

The animation SHALL play to completion before the page advance — the
existing 150 ms auto-advance delay SHALL be increased to accommodate it.

#### Scenario: Completion animation plays on final tap
- **GIVEN** a zikr with `repeat_count = N` and current count `N − 1`
- **WHEN** the user taps the card body
- **THEN** the count becomes `N`
- **AND** an animated checkmark icon appears with a brief scale-in (~280 ms)
- **AND** the existing "Done" label remains visible
- **AND** the auto-advance to the next zikr fires after the animation completes

#### Scenario: Haptic feedback fires on completion
- **GIVEN** a zikr is being counted
- **WHEN** the tap that triggers completion happens
- **THEN** a medium-impact haptic pulse fires once
- **AND** the haptic does NOT fire on intermediate (non-completing) taps

#### Scenario: Last zikr in the category does not auto-advance
- **GIVEN** the user is on the last zikr of a category
- **WHEN** they complete it
- **THEN** the animation and haptic still fire
- **AND** no auto-advance is attempted (existing behavior)

#### Scenario: Completion animation does not repeat on re-render
- **GIVEN** a zikr has already been completed
- **WHEN** the user navigates away and returns to that zikr's page
- **THEN** the checkmark is visible in its end state
- **AND** the scale-in animation does NOT replay
- **AND** no haptic fires
