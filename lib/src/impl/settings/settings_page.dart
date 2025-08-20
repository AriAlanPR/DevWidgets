import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/settings/settings_provider.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/themes.dart';
import 'package:dev_widgets/src/supported_locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: YaruSection(headline: "application".tr(), children: [
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.public),
          trailing: Text(
            "language".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           DropdownButton<Locale>(
              value: context.locale,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setLocale(context, value ?? const Locale("en_US"));
              },
              items: _getLanguageDropdownMenuItems()),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.dark_mode),
          trailing: Text(
            "brightness".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           DropdownButton<ThemeMode>(
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
                ref
                    .read(settingsProvider.notifier)
                    .setThemeMode(value ?? ThemeMode.system);
              }),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.accessibility),
          trailing: Text(
            "high_contrast".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           Switch(
            onChanged: (bool value) {
              ref.read(settingsProvider.notifier).setHighContrast(value);
            },
            value: settings.highContrast,
          ),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.brush),
          trailing: Text(
            "primary_color".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           Flexible(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
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
        ),
      ]),
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
      child: YaruSection(headline: "text_editor".tr(), children: [
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.edit),
          trailing: Text(
            "theme".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           DropdownButton<String?>(
              value: settings.textEditorTheme,
              items: _getTextEditorThemeDropdownMenuItems(),
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setTextEditorTheme(value ?? "vs");
              }),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.format_size),
          trailing: Text(
            "font_size".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           SizedBox(
              width: MediaQuery.of(context).size.width / 20,
              height: MediaQuery.of(context).size.height / 20,
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: TextEditingController(
                    text: settings.textEditorFontSize.toString()),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  double? parsedValue = double.tryParse(value);
                  if (parsedValue != null) {
                    ref
                        .read(settingsProvider.notifier)
                        .setTextEditorFontSize(parsedValue);
                  }
                },
              )),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.house),
          trailing: Text(
            "font_family".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           DropdownButton<String?>(
              value: settings.textEditorFontFamily,
              items: _getTextEditorFontFamilyDropdownMenuItems(),
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setTextEditorFontFamily(value ?? "Hack");
              }),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.wrap_text),
          trailing: Text(
            "wrap_text".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           Switch(
            onChanged: (bool value) {
              ref.read(settingsProvider.notifier).setTextEditorWrap(value);
            },
            value: settings.textEditorWrap,
          ),
        ),
        YaruTile(
          enabled: true,
          padding: const EdgeInsets.all(8.0),
          leading: const Icon(Icons.format_list_numbered),
          trailing: Text(
            "display_line_numbers".tr(),
            style: const TextStyle(fontSize: 18),
          ),
           Switch(
            onChanged: (bool value) {
              ref
                  .read(settingsProvider.notifier)
                  .setTextEditorDisplayLineNumbers(value);
            },
            value: settings.textEditorDisplayLineNumbers,
          ),
        ),
      ]),
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
      child: YaruSection(headline: "about".tr(), children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () =>
                showAboutDialog(context: context, useRootNavigator: false),
            child: YaruTile(
              enabled: true,
              trailing: Text(
                "licenses".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              description: "licenses_description".tr(),
              padding: const EdgeInsets.all(8.0),
               const SizedBox.shrink(),
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
            child: YaruTile(
              enabled: true,
              trailing: Text(
                "repository".tr(),
                style: const TextStyle(fontSize: 18),
              ),
              description: "repository_about".tr(),
              padding: const EdgeInsets.all(8.0),
               const SizedBox.shrink(),
              leading: const Icon(Icons.code),
            ),
          ),
        ),
        YaruTile(
          enabled: true,
          trailing: Text(
            "build_info".tr(),
            style: const TextStyle(fontSize: 18),
          ),
          description: buildInfo.when(
            loading: () => "...",
            data: (data) => data,
            error: (error, _) => error.toString(),
          ),
          padding: const EdgeInsets.all(8.0),
           const SizedBox.shrink(),
          leading: const Icon(Icons.computer),
        ),
      ]),
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
