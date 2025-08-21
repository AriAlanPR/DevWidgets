import 'package:dev_widgets/src/impl/formatters/indentation.dart';
import 'package:dev_widgets/src/impl/formatters/json_formatter/json_formatter_providers.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/code_controller_hook.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:highlight/languages/json.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class JsonFormatterPage extends HookConsumerWidget {
  const JsonFormatterPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final inputController = useCodeController(language: json);
    final outputController = useCodeController(language: json);

    useEffect(() {
      Future(() {
        inputController.addListener(() {
          ref.read(inputTextProvider.notifier).state = inputController.text;
        });
      });

      return;
    });

    useEffect(() {
      Future(() {
        try {
          outputController.text = ref.watch(outputTextProvider);
        } catch (_) {
          //Bug on text_code_field package.
        }
      });
      return;
    }, [ref.watch(outputTextProvider)]);

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: YaruSection(
              headline: Text(StringTranslateExtension("configuration").tr()),
              child: Column(
                children: [
                  YaruTile(
                    enabled: true,
                    leading: const Icon(Icons.arrow_right_alt),
                    trailing: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "indentation".tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        DropdownButton<Indentation>(
                            value: ref.watch(indentationProvider),
                            items: getDropdownMenuItems<Indentation>(
                                Indentation.values),
                            onChanged: (selected) => ref
                                .read(indentationProvider.notifier)
                                .state = selected!),
                      ],
                    ),
                  ),
                  YaruTile(
                    enabled: true,
                    leading: const Icon(Icons.sort_by_alpha),
                    trailing: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "sort_json_properties_alphabetically".tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Switch(
                          value: ref.watch(sortAlphabeticallyProvider),
                          onChanged: (value) => ref
                              .read(sortAlphabeticallyProvider.notifier)
                              .state = value,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: IOEditor(
              inputController: inputController,
              outputController: outputController,
            ),
          ),
        ],
      ),
    );
  }
}
