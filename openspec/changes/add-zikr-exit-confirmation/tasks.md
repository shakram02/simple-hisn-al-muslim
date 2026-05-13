# Tasks

## 1. Progress Detection
- [x] 1.1 Add `_hasUnsavedProgress()` helper to `_ZikrCategoryDetailScreenState` returning `true` iff at least one zikr in `categoryZikrList` has counter > 0 AND at least one zikr's counter is below its target `count`.
- [x] 1.2 Return `false` when `isLoading` is true or `categoryZikrList` is empty.

## 2. Back-Press Interception
- [x] 2.1 Wrap the screen's `Scaffold` in `PopScope`.
- [x] 2.2 Bind `canPop` to `!_hasUnsavedProgress()` so the screen pops immediately when nothing is at stake.
- [x] 2.3 In `onPopInvokedWithResult`, if `didPop` is false, show the confirmation dialog and pop manually on confirm.

## 3. Confirmation Dialog
- [x] 3.1 Add `_confirmExit()` returning `Future<bool>` that shows an `AlertDialog`.
- [x] 3.2 Title: `تأكيد الخروج`. Body: `سيتم فقدان تقدمك. هل تريد الخروج؟`.
- [x] 3.3 Two buttons: `إلغاء` (returns false, default focus) and `خروج` (returns true, styled in error/red).
- [x] 3.4 Wrap dialog in `Directionality(textDirection: TextDirection.rtl, ...)` to match the rest of the app.
- [x] 3.5 Guard `Navigator.pop` with `context.mounted` after the async dialog returns.

## 4. Verification
- [x] 4.1 `flutter analyze` passes with no new warnings.
- [ ] 4.2 Manual: open a category, increment one counter, press AppBar back → dialog appears; tap cancel → stays on screen, counter preserved.
- [ ] 4.3 Manual: same scenario, tap exit → returns to category list.
- [ ] 4.4 Manual: open a category and immediately press back → no dialog, pops instantly.
- [ ] 4.5 Manual: complete every zikr in a category, press back → no dialog, pops instantly.
- [ ] 4.6 Manual: with progress in flight, trigger Android system back / gesture back → same dialog appears.
