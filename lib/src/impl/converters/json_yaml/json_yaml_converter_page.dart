import 'package:dev_widgets/src/impl/converters/json_yaml/json_yaml_conversion_type.dart';
import 'package:dev_widgets/src/impl/converters/json_yaml/json_yaml_converter_providers.dart';
import 'package:dev_widgets/src/impl/formatters/indentation.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/code_controller_hook.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/yaml.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaru/yaru.dart';

class JsonYamlConverterPage extends HookConsumerWidget {
  const JsonYamlConverterPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final conversionType = ref.watch(conversionTypeProvider);

    final inputController = useCodeController();
    final outputController = useCodeController();

    useEffect(() {
      Future(() {
        inputController.language =
            conversionType == JsonYamlConversionType.jsonToYaml ? json : yaml;
        inputController.addListener(() {
          ref.read(inputTextProvider.notifier).state = inputController.text;
        });
      });

      return;
    });

    useEffect(() {
      Future(() {
        outputController.language =
            conversionType == JsonYamlConversionType.jsonToYaml ? yaml : json;
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
                      Icons.compare_arrows_sharp,
                      size: 25,
                    ),
                    title: Text(
                      "conversion_type".tr(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: DropdownButton<JsonYamlConversionType>(
                        value: ref.watch(conversionTypeProvider),
                        items: getDropdownMenuItems<JsonYamlConversionType>(
                            JsonYamlConversionType.values),
                        onChanged: (selected) => ref
                            .watch(conversionTypeProvider.notifier)
                            .state = selected!),
                  ),
                  Visibility(
                    visible: ref.watch(conversionTypeProvider) ==
                        JsonYamlConversionType.yamlToJson,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.arrow_right_alt),
                          title: Text(
                            "indentation".tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: DropdownButton<Indentation>(
                              value: ref.watch(indentationProvider),
                              items: getDropdownMenuItems<Indentation>(
                                  Indentation.values),
                              onChanged: (selected) => ref
                                  .read(indentationProvider.notifier)
                                  .state = selected!),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: ref.watch(conversionTypeProvider) ==
                          JsonYamlConversionType.jsonToYaml,
                      child: Column(children: [
                        ListTile(
                          leading: const Icon(Icons.arrow_right_alt),
                          title: Text(
                            "yaml_style".tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: DropdownButton<YamlStyle>(
                              value: ref.watch(yamlStyleProvider),
                              items: getYamlStyleDropdownMenuItems(),
                              onChanged: (selected) => ref
                                  .read(yamlStyleProvider.notifier)
                                  .state = selected!),
                        ),
                      ])),
                  ListTile(
                    enabled: true,
                    leading: const Icon(Icons.sort_by_alpha),
                    title: Text(
                      "sort_properties_alphabetically".tr(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Switch(
                      value: ref.watch(sortAlphabeticallyProvider),
                      onChanged: (value) => ref
                          .read(sortAlphabeticallyProvider.notifier)
                          .state = value,
                    ),
                  )
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