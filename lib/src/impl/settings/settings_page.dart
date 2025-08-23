import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/settings/settings_provider.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/themes.dart';
import 'package:dev_widgets/src/supported_locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru/yaru.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: ListView(
        children: const [
          _ApplicationSettings(),
          _TextEditorSettings(),
          _About(),
        ],
      ),
    );
  }
}

class _ApplicationSettings extends ConsumerWidget {
  const _ApplicationSettings();

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider);

    return Container(
      margin: const EdgeInsets.all(8.0),
         child: YaruSection(
        headline: Text("application".tr()),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: Text(
                "language".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: DropdownButton<Locale>(
                value: context.locale,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setLocale(context, value ?? const Locale("en_US"));
                },
                items: _getLanguageDropdownMenuItems(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(
                "brightness".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text("system".tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text("light".tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text("dark".tr()),
                  ),
                ],
                onChanged: (value) {
                  ref.read(settingsProvider.notifier)
                    .setThemeMode(value ?? ThemeMode.system);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.accessibility),
              title: Text(
                "high_contrast".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setHighContrast(value);
                },
                value: settings.highContrast,
              ),
            ),
            ListTile(
              title: const SizedBox.shrink(),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.brush, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "primary_color".tr(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var variant in YaruVariant.values)
                      YaruColorDisk(
                        onPressed: () {
                          ref
                              .read(settingsProvider.notifier)
                              .setYaruVariant(variant);
                        },
                        color: variant.color,
                        selected: settings.yaruVariant == variant,
                      ),
                  ],
                ),
              ),
              trailing: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextEditorSettings extends ConsumerWidget {
  const _TextEditorSettings();

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider);

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: YaruSection(
        headline: Text("text_editor".tr()),
        child: Column(
          children: [
            ListTile(
              title: const SizedBox.shrink(),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "theme".tr(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              trailing: DropdownButton<String?>(
                value: settings.textEditorTheme,
                items: _getTextEditorThemeDropdownMenuItems(),
                onChanged: (value) {
                  ref.read(settingsProvider.notifier)
                    .setTextEditorTheme(value ?? "vs");
                },
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withValues(alpha: .4),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: HighlightView(
                      'void main() {\n  final msg = "Hello";\n  print(msg);\n}',
                      language: 'dart',
                      theme: textEditorThemes[settings.textEditorTheme]!,
                      textStyle: TextStyle(
                        fontFamily: settings.textEditorFontFamily,
                        fontSize: settings.textEditorFontSize,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: Text(
                "font_size".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 20,
                height: MediaQuery.of(context).size.height / 20,
                child: TextFormField(
                  key: ValueKey(settings.textEditorFontSize),
                  initialValue: settings.textEditorFontSize.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$'))
                  ],
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setTextEditorFontSize(parsed);
                    }
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.house),
              title: Text(
                "font_family".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: DropdownButton<String?>(
                value: settings.textEditorFontFamily,
                items: _getTextEditorFontFamilyDropdownMenuItems(),
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setTextEditorFontFamily(value ?? "Hack");
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.wrap_text),
              title: Text(
                "wrap_text".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setTextEditorWrap(value);
                },
                value: settings.textEditorWrap,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered),
              title: Text(
                "display_line_numbers".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setTextEditorDisplayLineNumbers(value);
                },
                value: settings.textEditorDisplayLineNumbers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _About extends ConsumerWidget {
  const _About();

  @override
  Widget build(BuildContext context, ref) {
    final buildInfo = ref.watch(buildInfoProvider);

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: YaruSection(
        headline: Text("about".tr()),
        child: Column(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () =>
                    showAboutDialog(context: context, useRootNavigator: false),
                child: ListTile(
                  title: Text(
                    "licenses".tr(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text("licenses_description".tr()),
                  trailing: const SizedBox.shrink(),
                  leading: const Icon(Icons.document_scanner),
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await launchUrl(
                      Uri.parse("https://www.github.com/gumbarros/DevWidgets"));
                },
                child: ListTile(
                  title: Text(
                    "repository".tr(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text("repository_about".tr()),
                  trailing: const SizedBox.shrink(),
                  leading: const Icon(Icons.code),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "build_info".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: buildInfo.when(
                loading: () => Text("..."),
                data: (data) => Text(data),
                error: (error, _) => Text(error.toString()),
              ),
              trailing: const SizedBox.shrink(),
              leading: const Icon(Icons.computer),
            ),
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<Locale>> _getLanguageDropdownMenuItems() {
  return supportedLocales
      .map((l) => DropdownMenuItem(
            value: l.locale,
            child: Text(l.name),
          ))
      .toList();
}

List<DropdownMenuItem<String>> _getTextEditorThemeDropdownMenuItems() {
  return textEditorThemes.entries
      .map((e) => DropdownMenuItem(
            value: e.key,
            child: Text(e.key),
          ))
      .toList();
}

List<DropdownMenuItem<String>> _getTextEditorFontFamilyDropdownMenuItems() {
  return supportedFontFamilies
      .map((family) => DropdownMenuItem(
            value: family,
            child: Text(family),
          ))
      .toList();
}
