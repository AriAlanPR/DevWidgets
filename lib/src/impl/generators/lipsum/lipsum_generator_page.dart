import 'package:dev_widgets/src/impl/generators/lipsum/lipsum_generator_providers.dart';
import 'package:dev_widgets/src/impl/generators/lipsum/lipsum_type.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/output_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class LipsumGeneratorPage extends HookConsumerWidget {
  const LipsumGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final outputController = useTextEditingController();

    useEffect(() {
      Future(() => outputController.text = ref.watch(outputTextProvider));
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
                    leading: const Icon(Icons.width_normal),
                    trailing: Row(
                      // Keep trailing compact to avoid infinite constraints
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(StringTranslateExtension(
                                      "lipsum_generator_mode")
                                  .tr()),
                              Text(StringTranslateExtension(
                                      "lipsum_generator_mode_description")
                                  .tr()),
                            ],
                          ),
                        ),
                        DropdownButton<LipsumType>(
                            value: ref.watch(lipsumTypeProvider),
                            items: getDropdownMenuItems<LipsumType>(
                                LipsumType.values),
                            onChanged: (selected) => ref
                                .read(lipsumTypeProvider.notifier)
                                .state = selected!),
                      ],
                    ),
                  ),
                  YaruTile(
                    enabled: true,
                    leading: const Icon(Icons.fork_right),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              StringTranslateExtension("lipsum_start_with")
                                  .tr()),
                        ),
                        Switch(
                          onChanged: (value) => ref
                              .read(startWithLoremProvider.notifier)
                              .state = value,
                          value: ref.watch(startWithLoremProvider),
                        ),
                      ],
                    ),
                  ),
                  YaruTile(
                    enabled: true,
                    leading: const Icon(Icons.tag),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(StringTranslateExtension("amount").tr()),
                              Text(StringTranslateExtension(
                                      "lipsum_amount_description")
                                  .tr()),
                            ],
                          ),
                        ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: OutputEditor(
                outputController: outputController,
              )),
        ],
      ),
    );
  }
}
