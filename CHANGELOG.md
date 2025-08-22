# Changelog

All notable changes to this fork will be documented in this file.

## [0.1.2] - 2025-08-22

### Fixed

- Non-text file uploads in the input editor no longer crash the app when trying to decode binary data as UTF-8.
  - Web: use `utf8.decode(bytes)` with `try/catch` for `FormatException`.
  - Desktop: keep `readAsString()` with `try/catch` for `FileSystemException`.
  - On error, show localized SnackBars and do not modify the input content.
  - Added `if (!context.mounted) return;` guard before showing SnackBars.

#### Code editor

- Prevented vertical overflow when content exceeds the fixed container height.
  - In `lib/src/impl/widgets/io_editor/io_editor.dart`, set `expands: true` so the inner field scrolls instead of overflowing.
- Multi‑digit line numbers no longer get hidden or wrap to multiple lines.
  - In `lib/src/impl/widgets/io_editor/code_editor_wrapper.dart`, the gutter width is measured with `TextPainter`, reserving at least 4 digits and adding padding.
  - Right‑aligned numbers and consistent gutter margin.
  - Matching typography metrics between code and line numbers (same `TextStyle`, `textBaseline`, and `height`) to ensure vertical alignment.

### Changes

- Localization: added new keys and replaced hardcoded strings related to the Base64 Image encoder.
  - Keys added: `open`, `nothing_to_download`, `saved_image_to`, `failed_to_save_image`, `file_not_text`, `failed_to_read_file`.
  - Updated translation files: `assets/translations/en-US.yaml`, `assets/translations/es-ES.yaml`.
  - Updated translation template for contributors: `assets/templates/translation.yaml`.

### Updated files

- `lib/src/impl/widgets/io_editor/input_toolbar.dart`
- `lib/src/impl/encoders/base64_image/base64_image_encoder_providers.dart`
- `assets/translations/en-US.yaml`
- `assets/translations/es-ES.yaml`
- `assets/templates/translation.yaml`
 - `lib/src/impl/widgets/io_editor/code_editor_wrapper.dart`
 - `lib/src/impl/widgets/io_editor/io_editor.dart`

## [0.1.1] - 2025-08-21

### Changes

- Standardized configuration rows: replaced `YaruTile` with `ListTile` to improve visual consistency and avoid constraint issues on web/desktop.
- Dialog titles: replaced `YaruTile`-based titles with a compact `ListTile` + close button in the Text Diff dialog.

### Updated files

- `lib/src/impl/formatters/sql_formatter/sql_formatter_page.dart`
- `lib/src/impl/text/text_diff/text_diff_page.dart`
- `lib/src/impl/generators/uuid/uuid_generator_page.dart`
- `lib/src/impl/generators/lipsum/lipsum_generator_page.dart`
- `lib/src/impl/brazil/cpf_cnpj/cpf_cnpj_generator_page.dart`
- `lib/src/impl/converters/json_to_class/json_to_class_converter_page.dart`
- `lib/src/impl/converters/json_yaml/json_yaml_converter_page.dart`

### Linux packaging

- New AppStream metainfo: `mx.com.digicodev.DevWidgets.metainfo.xml`
- New desktop file: `mx.com.digicodev.DevWidgets.desktop`
- New Flatpak manifest: `mx.com.digicodev.yml`
- `linux/CMakeLists.txt`: updated `APPLICATION_ID` to `mx.com.digicodev.DevWidgets`
- Removed old metainfo: `br.com.barros.DevWidgets.metainfo.xml`

### Notes

- No logic changes; existing providers and behavior remain the same. The new layout keeps controls compact and stable.
- Dense forms (e.g., `json_to_sql_converter_options.dart`) and app Settings (`settings_page.dart`) will be evaluated separately to preserve ergonomics.

## [0.1.0] - 2025-08-21

### Highlights

- Resolved multiple layout crashes ("BoxConstraints forces an infinite width") across pages by constraining trailing content on `YaruTile` and removing `ListTile` usage inside trailing rows.
- Updated documentation: new root `README.md`; original upstream README preserved in `legacydocs/README.md`.

### Fixed

- UI layout constraints on desktop/web:
  - Set `mainAxisSize: MainAxisSize.min` on trailing `Row`s where applicable.
  - Replaced `ListTile` inside trailing Rows with `Column(Text, Text)` to avoid unbounded expansion.
  - Constrained wide widgets (e.g., settings color palette) with finite width containers.
  - Files touched (round 1):
    - `lib/src/impl/text/text_escape/text_escape_page.dart`
    - `lib/src/impl/encoders/base64_text/base64_text_encoder_page.dart`
    - `lib/src/impl/encoders/html/html_encoder_page.dart`
    - `lib/src/impl/encoders/url/url_encoder_page.dart`
    - `lib/src/impl/settings/settings_page.dart`
    - `lib/src/impl/converters/json_yaml/json_yaml_converter_page.dart`
- Fixed web import issue with an override declaration in `pubspec.yaml` (ensures web build compatibility).
- Fixed compatibility issues with Yaru components (adjusted usage to current API and constraints).
- Code fixes to match current package statuses (as of 21 August 2025): minor API updates, safer map detection (`_isMap(dynamic value)`).

### Changed

- README replaced with a fork-specific overview and setup instructions.
- Original README moved to `legacydocs/README.md` for historical reference (license preserved in `LICENSE`).

### Migraciones y cambios de APIs (realizados en esta iteración)

- Yaru (paquete `yaru`):
  - Importaciones migradas de `yaru_widgets/yaru_widgets.dart` a `yaru/yaru.dart` donde aplica.
  - `YaruRow` → `YaruTile`. Propiedades actualizadas: uso de `leading` y `trailing` con `Row` para agrupar controles (e.g., `DropdownButton`, `Switch`).
  - `YaruSection`: propiedad `children` reemplazada por `child`. Se envolvieron los contenidos en `Column` para mantener múltiples filas/tiles. En algunos casos `headline` ahora es `Widget` (se usó `Text(...)`).
  - `YaruExpansionPanelList` eliminado → reemplazado por `ExpansionPanelList` nativo de Flutter (o `ExpansionPanelList.radio` si se requiere selección única).
  - Páginas actualizadas: `settings_page.dart`, `json_yaml_converter_page.dart`, `xml_formatter_page.dart`, `json_to_class_converter_page.dart`, `cpf_cnpj_generator_page.dart`, entre otras.

- MultiSplitView:
  - Migrado al nuevo `builder: (context, area) { ... }` (ya no se recibe índice directo; se usa `area.index`).
  - Se utilizan `initialAreas` y el `builder` para devolver los paneles (e.g., `InputEditor` de texto diff). Se ajustaron mínimos mediante constraints cuando aplica.

- Pestañas (tabs):
  - `YaruTabbedPage` eliminado → migrado a `DefaultTabController` + `TabBar` + `TabBarView`. Se creó un contenedor ligero local (`TabbedPage`) para simplificar el uso y mantener `onTap` sincronizado con `Riverpod`.

- DropdownSearch (búsqueda del menú lateral):
  - API actualizada: `dropdownDecoratorProps.dropdownSearchDecoration` → `decoratorProps.decoration`.
  - `items` ahora es una función: `FutureOr<List<T>> Function(String, LoadProps?)`. Se implementó filtrado por texto y `itemAsString` para la presentación.

- Responsive Framework:
  - `ResponsiveWrapper.builder` eliminado → `ResponsiveBreakpoints.builder`.
  - `breakpoints` migrados a la sintaxis v3 con `Breakpoint(start:, end:, name:)` y nombres usados en el layout (e.g., `'TABLET_LARGE'`).
  - `ResponsiveVisibility`: `hiddenWhen` → `hiddenConditions`.

- Otros ajustes menores:
  - Uso de `Color.withValues(alpha: ...)` donde corresponde (API moderna de colores).
  - Limpieza y compatibilidad de imports (e.g., `responsive_framework/responsive_framework.dart`).

### Notes

- Additional pages may receive the same trailing constraints treatment in subsequent versions.
- Target platforms: Linux, macOS, Windows, Web (Flutter stable).

