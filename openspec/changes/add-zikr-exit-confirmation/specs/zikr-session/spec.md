# Zikr Session — Spec Delta

## ADDED Requirements

### Requirement: Guard Exit From In-Progress Session
The system SHALL prompt the user to confirm before leaving the Zikr category detail screen when the session contains progress that would be lost.

A session has *progress to lose* if and only if **both** conditions hold:
- at least one zikr in the category has a current counter greater than zero, AND
- at least one zikr in the category has a current counter less than its target count.

When either condition is false, back navigation SHALL pop the screen immediately without any prompt.

The guard SHALL apply uniformly to:
- the AppBar back button,
- the Android system back button,
- predictive-back / gesture-back navigation.

#### Scenario: Back press with mid-session progress
- **GIVEN** the user is on the Zikr category detail screen
- **AND** at least one zikr's counter is greater than zero
- **AND** at least one zikr is not yet fully completed
- **WHEN** the user presses any back affordance
- **THEN** the system displays a confirmation dialog
- **AND** the screen remains visible until the user chooses an action

#### Scenario: Confirm exit
- **GIVEN** the confirmation dialog is shown
- **WHEN** the user taps the exit action
- **THEN** the dialog closes
- **AND** the system pops the route, returning to the previous screen
- **AND** in-memory counters for this session are discarded

#### Scenario: Cancel exit
- **GIVEN** the confirmation dialog is shown
- **WHEN** the user taps the cancel action or dismisses the dialog
- **THEN** the dialog closes
- **AND** the user remains on the Zikr category detail screen
- **AND** all counters are preserved

#### Scenario: No progress yet
- **GIVEN** the user has just opened the Zikr category detail screen
- **AND** every zikr's counter is still zero
- **WHEN** the user presses back
- **THEN** the screen pops immediately
- **AND** no confirmation dialog is shown

#### Scenario: Session already complete
- **GIVEN** every zikr in the category has reached its target count
- **WHEN** the user presses back
- **THEN** the screen pops immediately
- **AND** no confirmation dialog is shown

#### Scenario: Screen still loading
- **GIVEN** the Zikr category detail screen is still loading its data
- **WHEN** the user presses back
- **THEN** the screen pops immediately
- **AND** no confirmation dialog is shown

### Requirement: Confirmation Dialog Content
The confirmation dialog SHALL be presented in Arabic with right-to-left text direction, consistent with the rest of the app.

The dialog SHALL include:
- a title that names the action being confirmed,
- a body that explains progress will be lost,
- a cancel action that keeps the user on the screen (default focus),
- an exit action visually distinguished as destructive.

#### Scenario: Dialog presentation
- **WHEN** the confirmation dialog is displayed
- **THEN** the title reads `تأكيد الخروج`
- **AND** the body reads `سيتم فقدان تقدمك. هل تريد الخروج؟`
- **AND** the cancel button is labeled `إلغاء`
- **AND** the exit button is labeled `خروج` and rendered in the theme's error color
