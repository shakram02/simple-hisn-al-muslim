# Audio Playback — Spec Delta

## ADDED Requirements

### Requirement: Per-item audio playback with one-time download and local cache

Each zikr item with an `audio_url` SHALL show a play control on its card.
Tapping the control SHALL play the audio. The audio file SHALL be
downloaded on the first play and cached locally in app-private storage;
subsequent plays SHALL read from the cache without making a network
request.

At most one audio stream SHALL play at any time. Starting a new play
SHALL stop the currently-playing one. Navigating away from a screen
with a playing audio SHALL stop it gracefully.

When playback completes naturally, the control SHALL return to its
"ready to play" state.

When there is no internet AND the file is not cached, the app SHALL
present a non-fatal error and the play control SHALL return to its
"ready to play" state — the rest of the UI continues to work.

#### Scenario: First play of a zikr — download then play
- **GIVEN** the user is viewing a zikr card with audio
- **AND** no cached audio file exists for that item
- **WHEN** the user taps play
- **THEN** the control shows a loading indicator
- **AND** the audio file is downloaded to `<docs>/audio_cache/<item_id>.mp3`
- **AND** playback begins
- **AND** the control shows the "playing" state

#### Scenario: Subsequent play — cache hit, no network
- **GIVEN** the user has previously played a zikr's audio (file is cached)
- **WHEN** the user taps play again
- **THEN** playback begins immediately
- **AND** no network request is issued

#### Scenario: Only one audio plays at a time
- **GIVEN** zikr A is currently playing audio
- **WHEN** the user taps play on zikr B
- **THEN** zikr A's audio stops
- **AND** zikr B's audio begins

#### Scenario: Navigating away stops audio
- **GIVEN** a zikr's audio is playing
- **WHEN** the user navigates back to the categories screen
- **THEN** the audio stops within 200 ms

#### Scenario: Offline + no cache — graceful failure
- **GIVEN** the device has no internet connection
- **AND** the requested zikr's audio is not cached
- **WHEN** the user taps play
- **THEN** the app shows a brief error message localized to the active locale
- **AND** the control returns to "ready to play"
- **AND** no app crash or hang occurs

#### Scenario: Download fails mid-fetch
- **GIVEN** a download starts but fails before completion
- **WHEN** the failure occurs
- **THEN** no partial file is written to the cache
- **AND** the next play attempt re-downloads from scratch

#### Scenario: Audio finishes naturally
- **GIVEN** a zikr's audio has played to the end
- **WHEN** playback completes
- **THEN** the play control returns to "ready to play"
- **AND** the user can replay by tapping again

#### Scenario: Repeat-count counter is independent of audio
- **GIVEN** a zikr has `repeat_count > 1`
- **AND** the user is using both the counter and audio
- **WHEN** the user taps the body of the card (to count)
- **THEN** the count advances normally without interrupting audio playback
- **AND** when the user taps play, audio plays without affecting the count
