import 'package:dev_widgets/src/impl/encoders/base64_text/base64_encoding_type.dart';
import 'package:dev_widgets/src/impl/encoders/base64_text/base64_text_encoder_providers.dart';
import 'package:dev_widgets/src/impl/encoders/encode_conversion_mode.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class Base64TextEncoderPage extends HookConsumerWidget {
  const Base64TextEncoderPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final inputController = useTextEditingController();
    final outputController = useTextEditingController();

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
              headline: Text(StringTranslateExtension("configuration").tr()),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.compare_arrows_sharp),
                    title: Text(StringTranslateExtension("conversion").tr()),
                    subtitle: Text(StringTranslateExtension("conversion_mode").tr()),
                    trailing: DropdownButton<ConversionMode>(
                      value: ref.watch(conversionModeProvider),
                      items: getDropdownMenuItems<ConversionMode>(
                          ConversionMode.values),
                      onChanged: (selected) {
                        ref.read(conversionModeProvider.notifier).state =
                            selected!;
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.grid_3x3),
                    title: Text(StringTranslateExtension("encoding").tr()),
                    subtitle: Text(StringTranslateExtension("encoding_description").tr()),
                    trailing: DropdownButton<Base64EncodingType>(
                      value: ref.watch(encodingTypeProvider),
                      items: getDropdownMenuItems<Base64EncodingType>(
                          Base64EncodingType.values),
                      onChanged: (selected) {
                        ref.read(encodingTypeProvider.notifier).state =
                            selected!;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          IOEditor(
            inputController: inputController,
            usesCodeControllers: false,
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
