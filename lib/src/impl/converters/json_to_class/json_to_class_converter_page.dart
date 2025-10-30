import 'package:dev_widgets/src/impl/converters/json_to_class/json_to_class_converter_providers.dart';
import 'package:dev_widgets/src/impl/converters/json_to_class/programming_language.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/code_controller_hook.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/json.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class JsonToClassConverterPage extends HookConsumerWidget {
  const JsonToClassConverterPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final inputController = useCodeController(language: json);
    final outputController = useCodeController(language: dart);

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
        return outputController.text = ref.watch(outputTextProvider);
      });
      return;
    }, [ref.watch(outputTextProvider)]);

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: YaruSection(
              headline: Text("configuration".tr()),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.title,
                      size: 25,
                    ),
                    title: Text("class_name".tr()),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue: ref.read(classNameProvider),
                        onChanged: (value) {
                          ref.read(classNameProvider.notifier).state = value;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.code,
                      size: 25,
                    ),
                    title: Text(
                      StringTranslateExtension("programming_language").tr(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: DropdownButton<ProgrammingLanguage>(
                        value: ref.watch(programmingLanguageProvider),
                        items: getDropdownMenuItems<ProgrammingLanguage>(
                            ProgrammingLanguage.values),
                        onChanged: (selected) => ref
                            .read(programmingLanguageProvider.notifier)
                            .state = selected!),
                  ),
                ],
              ),
            ),
          ),
          IOEditor(
            inputController: inputController,
            outputController: outputController,
            singleScroll: true,
            useExpansionPanels: true,
            inputInitiallyExpanded: true,
            outputInitiallyExpanded: true,
          ),
        ],
      ),
    );
  }
}