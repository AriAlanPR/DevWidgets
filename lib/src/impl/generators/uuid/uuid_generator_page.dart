import 'package:dev_widgets/src/impl/generators/uuid/uuid_generator_providers.dart';
import 'package:dev_widgets/src/impl/generators/uuid/uuid_type.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/output_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class UuidGeneratorPage extends HookConsumerWidget {
  const UuidGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final outputController = useTextEditingController();

    useEffect(() {
      Future(() => outputController.text = ref.watch(uuidGeneratorProvider));
      return;
    }, [ref.watch(uuidGeneratorProvider)]);

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: YaruSection(
              headline: Text(StringTranslateExtension("configuration").tr()),
              child: Column(children: [
                YaruTile(
                  enabled: true,
                  leading: const Icon(Icons.tag),
                  trailing: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                          title:
                              Text(StringTranslateExtension("uuid_type").tr()),
                          subtitle: Text(
                              StringTranslateExtension("uuid_type_description")
                                  .tr()),
                        ),
                      ),
                      DropdownButton<UuidType>(
                          value: ref.watch(uuidTypeProvider),
                          items:
                              getDropdownMenuItems<UuidType>(UuidType.values),
                          onChanged: (selected) => ref
                              .read(uuidTypeProvider.notifier)
                              .state = selected!),
                    ],
                  ),
                ),
                YaruTile(
                  enabled: true,
                  leading: const Icon(Icons.remove),
                  trailing: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                          title: Text("hyphens".tr()),
                        ),
                      ),
                      Switch(
                        onChanged: (value) =>
                            ref.read(hiphensProvider.notifier).state = value,
                        value: ref.watch(hiphensProvider),
                      ),
                    ],
                  ),
                ),
                YaruTile(
                  enabled: true,
                  leading: const Icon(Icons.format_color_text),
                  trailing: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: ListTile(title: Text("uppercase".tr())),
                      ),
                      Switch(
                        onChanged: (value) =>
                            ref.read(uppercaseProvider.notifier).state = value,
                        value: ref.watch(uppercaseProvider),
                      ),
                    ],
                  ),
                ),
                YaruTile(
                  enabled: true,
                  leading: const Icon(Icons.format_list_numbered),
                  trailing: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                            title:
                                Text(StringTranslateExtension("amount").tr())),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.end,
                                initialValue:
                                    ref.watch(amountProvider).toString(),
                                onChanged: (value) {
                                  ref.read(amountProvider.notifier).state =
                                      int.tryParse(value) ?? 0;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () => ref
                                    .read(uuidGeneratorProvider.notifier)
                                    .generate(),
                                child: Text(
                                    StringTranslateExtension("generate")
                                        .tr()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: OutputEditor(
              outputController: outputController,
              actionButtons: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.clear),
                  label: Text("clear".tr()),
                  onPressed: () =>
                      ref.read(uuidGeneratorProvider.notifier).clear(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
