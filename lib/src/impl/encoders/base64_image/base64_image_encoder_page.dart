import 'dart:convert';

import 'package:dev_widgets/src/impl/encoders/base64_image/base64_image_encoder_providers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_toolbar.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/output_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screenshot/screenshot.dart';

class Base64ImageEncoderPage extends HookConsumerWidget {
  const Base64ImageEncoderPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final inputController = useTextEditingController();
    final hasImage = ref.watch(outputImageProvider).isNotEmpty;

    useEffect(() {
      Future(() {
        inputController.text = ref.watch(inputTextProvider);
        inputController.addListener(() {
          try {
            final text = inputController.text.trim();
            if (text.isEmpty) {
              ref.read(outputImageProvider.notifier).state = Uint8List(0);
              return;
            }
            final bytes = const Base64Decoder().convert(text);
            ref.read(outputImageProvider.notifier).state = bytes;
          } catch (_) {
            // If invalid base64, clear the image output silently.
            ref.read(outputImageProvider.notifier).state = Uint8List(0);
          }
        });
      });
      return;
    }, [ref.watch(inputTextProvider)]);

    return SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          children: [
            IOEditor(
                usesCodeControllers: false,
                singleScroll: true,
                useExpansionPanels: true,
                inputInitiallyExpanded: true,
                outputInitiallyExpanded: true,
                inputController: inputController,
                outputChild: Column(
                  children: [
                    IOToolbar(
                      title: "output".tr(),
                      actions: [
                        ElevatedButton.icon(
                            onPressed: () => uploadImage(ref),
                            icon: const Icon(Icons.image),
                            label: Text(
                              StringTranslateExtension("upload_image").tr(),
                            )),
                        Visibility(
                          visible: !kIsWeb,
                          child: ElevatedButton.icon(
                              onPressed: hasImage ? () => downloadImage(context, ref) : null,
                              icon: const Icon(Icons.download),
                              label: Text("download_image".tr())),
                        )
                      ],
                    ),
                    OutputEditor(
                        outputController: null,
                        outputChild: Screenshot(
                          controller: ref.watch(screenshotControllerProvider),
                          child: Image.memory(
                            ref.watch(outputImageProvider),
                            errorBuilder: ((_, __, ___) =>
                                const SizedBox.shrink()),
                          ),
                        ),
                        usesCodeControllers: false,
                        isVerticalLayout: false),
                  ],
                )),
          ],
        ));
  }
}

