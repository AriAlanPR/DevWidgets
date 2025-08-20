# DevWidgets (Fork)

DevWidgets is a Flutter desktop/web app that bundles common developer tools: generators, converters, formatters, and encoders.
This fork focuses on stability, UI fixes, and maintainability for desktop and web builds.

- Website (original): https://gumbarros.github.io/DevWidgets
- Upstream: https://github.com/gumbarros/DevWidgets
  - Upstream README: https://github.com/gumbarros/DevWidgets/blob/main/README.md
  - Original README in this repo: `legacydocs/README.md`

## Features

- Generators: UUID, Lorem Ipsum, CPF/CNPJ (BR), and more
- Converters: JSON ↔ YAML, JSON → SQL, JSON → Class
- Formatters: JSON, SQL, YAML, XML
- Encoders: Base64, URL, HTML
- Cross‑platform: Linux, macOS, Windows, Web

## What’s new in this fork

Stability and layout fixes to prevent constraint errors on desktop/web. Highlights:

- Trailing UI on `YaruTile` is now sized intrinsically to avoid infinite width:
  - Set `mainAxisSize: MainAxisSize.min` on trailing `Row`s (where applicable).
  - Replaced `ListTile` inside trailing rows with a `Column(Text, Text)` to prevent unbounded expansion.
  - Constrained wide widgets (e.g., color palette) with finite width containers.

Updated files (round 1):

- `lib/src/impl/text/text_escape/text_escape_page.dart`
- `lib/src/impl/encoders/base64_text/base64_text_encoder_page.dart`
- `lib/src/impl/encoders/html/html_encoder_page.dart`
- `lib/src/impl/encoders/url/url_encoder_page.dart`
- `lib/src/impl/settings/settings_page.dart` (primary color grid width; some trailing rows constrained)
- `lib/src/impl/converters/json_yaml/json_yaml_converter_page.dart` (some trailing rows constrained)

## Changelog

See the full changelog in [`CHANGELOG.md`](CHANGELOG.md).

Other changes:

- Safer map detection in JSON→SQL helper: `_isMap(dynamic value)`.
- Moved the original README to `legacydocs/README.md` for reference; license preserved in `LICENSE`.

## Getting Started

### Prerequisites

- Flutter (stable channel recommended). Check: `flutter --version`
- A recent Dart SDK is bundled with Flutter.

### Install dependencies

```bash
flutter pub get
```

### Run (desktop)

```bash
# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Windows
flutter run -d windows
```

### Run (web)

```bash
flutter run -d chrome
```

## Build

```bash
# macOS app
flutter build macos

# Linux app
flutter build linux

# Windows app
flutter build windows

# Web (release)
flutter build web
```

## Project structure

- `lib/src/impl/` — Features by domain (text, encoders, converters, formatters, generators, settings)
- `assets/` — Icons and translations
- `web/` — PWA shell
- `legacydocs/` — Original upstream README retained for reference

## Contributing

Issues and PRs are welcome. Please:

- Keep changes minimal and focused.
- Add clear commit messages and short rationale for UI/layout changes.
- Prefer fixes that maintain finite constraints for desktop/web.

## License

This project remains under the upstream project’s license. See `LICENSE`.
Credits to the original authors/maintainers of DevWidgets.

## Acknowledgements

- Upstream DevWidgets project and contributors
- Yaru UI components
- Riverpod, Hooks, Multi Split View, and other libraries used in this app
