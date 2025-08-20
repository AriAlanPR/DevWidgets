# Changelog

All notable changes to this fork will be documented in this file.

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

