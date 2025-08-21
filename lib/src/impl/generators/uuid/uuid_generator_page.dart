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
                ListTile(
                  leading: const Icon(Icons.tag),
                  title: Text(StringTranslateExtension("uuid_type").tr()),
                  subtitle: Text(
                    StringTranslateExtension("uuid_type_description").tr(),
                  ),
                  trailing: DropdownButton<UuidType>(
                      value: ref.watch(uuidTypeProvider),
                      items:
                          getDropdownMenuItems<UuidType>(UuidType.values),
                      onChanged: (selected) => ref
                          .read(uuidTypeProvider.notifier)
                          .state = selected!),
                ),
                ListTile(
                  leading: const Icon(Icons.remove),
                  title: Text("hyphens".tr()),
                  trailing: Switch(
                    onChanged: (value) =>
                        ref.read(hiphensProvider.notifier).state = value,
                    value: ref.watch(hiphensProvider),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.format_color_text),
                  title: Text("uppercase".tr()),
                  trailing: Switch(
                    onChanged: (value) =>
                        ref.read(uppercaseProvider.notifier).state = value,
                    value: ref.watch(uppercaseProvider),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.format_list_numbered),
                  title: Text(StringTranslateExtension("amount").tr()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.end,
                          initialValue: ref.watch(amountProvider).toString(),
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
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(uuidGeneratorProvider.notifier).generate(),
                        child:
                            Text(StringTranslateExtension("generate").tr()),
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
