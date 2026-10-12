# Post Reader & Favorites — ITP107 Flutter Project

A dark-blue neon fantasy themed Flutter app using the provided monster characters and moonlit waterfall background.

## Run in VS Code
1. Extract this ZIP and open the project root folder (the folder containing `pubspec.yaml`) in VS Code.
2. Open **Terminal → New Terminal**.
3. Run `flutter pub get`.
4. Start an Android emulator or connect a device. Check with `flutter devices`.
5. Run `flutter run`.

## ITP107 requirement checklist
- Named routes `/`, `/details`, `/favorites` declared in `MaterialApp`.
- `Navigator.pushNamed`, `Navigator.pop`, and `ModalRoute.of(context)!.settings.arguments`.
- HTTP GET to JSONPlaceholder from `initState`, `jsonDecode`, status check, visible loading/error state and retry.
- POST using `http.post` and `jsonEncode`, non-empty title/body validation, visible success/failure feedback.
- Hive initialized before `runApp`; `favoritesBox` opened.
- Favorites create/read/update/delete, duplicate-save prevention, editable personal notes, and persisted local data.
- `ValueListenableBuilder` updates the Favorites view after Hive changes.
- Separate screen classes and a shared theme/background/components for consistency.

## API note
JSONPlaceholder is a demonstration API. It usually returns status 201 for POST, but does not permanently store the submitted post on its server. Saved favorites and notes persist locally using Hive.

## Assets
`assets/images/fantasy_background.jpg` is the generated moonlit fantasy background. `assets/images/monsters/` contains 24 individual monster images, and the UI cycles through the collection for post cards and details. `monster_sheet.png` contains the original generated sheet.

## Important exam note
The exam instructions state that AI-generated code is not permitted. Use this project as a learning reference only if your instructor permits it, and make sure you understand and are allowed to submit every part of the implementation.
