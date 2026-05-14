# Search — Spec Delta

## ADDED Requirements

### Requirement: In-app search across the active locale

The app SHALL provide a search input at the top of the categories screen
that returns matching zikr items across all 132 categories in the user's
active locale.

The query SHALL match zikr `markup` content via the bundled FTS5 index,
with diacritic-insensitive matching (so Arabic searches succeed without
tashkeel marks and Latin-script searches succeed without diacritics).
The query SHALL be prefix-matched: typing "subhan" finds "subhanaka",
"subhanallah", etc.

Results SHALL include enough context to be useful:
- the category title in the active locale,
- a short snippet of the matched text showing the query in context,
- enough metadata to navigate directly to the item on tap.

#### Scenario: Typing a query reveals results
- **GIVEN** the user is on the categories screen in any locale
- **WHEN** the user types a non-empty term into the search input
- **THEN** the categories list is replaced by a results list
- **AND** results show category title + snippet
- **AND** results update on every keystroke without a separate submit

#### Scenario: Clearing the search restores the categories list
- **WHEN** the user clears the search input
- **THEN** the categories list returns to its prior state (favorites first,
  then alphabetical / display_order)

#### Scenario: Empty query is treated as no query
- **WHEN** the search input contains only whitespace
- **THEN** the categories list is shown (same as having no input)

#### Scenario: No results found
- **GIVEN** the user has entered a query that matches nothing
- **WHEN** the search index returns zero rows
- **THEN** the screen shows an empty-state message in the active locale

#### Scenario: Tapping a result opens the item's category
- **WHEN** the user taps a search result
- **THEN** the zikr category screen opens for that result's category
- **AND** the screen positions on the matching item (not always the first item)

#### Scenario: Arabic search ignores diacritics
- **GIVEN** the active locale is `ar`
- **AND** the source markup contains `أَصْبَحْنَا` (fully voweled)
- **WHEN** the user types `اصبحنا` (no diacritics)
- **THEN** the source item is returned in the result list

#### Scenario: Search is locale-scoped
- **GIVEN** the active locale is `en`
- **WHEN** the user searches for "subhan"
- **THEN** results are drawn only from English translations
- **AND** changing locale and re-issuing the same query yields locale-appropriate results
