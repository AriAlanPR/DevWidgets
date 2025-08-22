import 'dart:convert';

import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_toolbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:easy_localization/easy_localization.dart';

class InputToolBar extends StatelessWidget {
  final TextEditingController inputController;

  final String? toolbarTitle;

  const InputToolBar(
      {super.key, required this.inputController, this.toolbarTitle});

  @override
  Widget build(BuildContext context) {
    return IOToolbar(title: toolbarTitle ?? "input".tr(), actions: [
      ElevatedButton.icon(
        icon: const Icon(Icons.copy),
        label: Text("copy".tr()),
        onPressed: () async => await copyToClipboard(inputController.text),
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.paste),
        label: Text("paste".tr()),
        onPressed: () async {
          inputController.text = await Clipboard.getData("text/plain")
              .then((value) => value?.text ?? "");
        },
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.upload),
        label: Text("upload_file".tr()),
        onPressed: () async {
          var result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final picked = result.files.single;
            final fileName = picked.name;
            try {
              if (kIsWeb) {
                final bytes = picked.bytes;
                if (bytes == null) return;
                // Try strict UTF-8 decode; throws FormatException if not text
                final decoded = utf8.decode(bytes);
                inputController.text = decoded;
              } else {
                final file = io.File(picked.path!);
                // readAsString will throw for non-text encodings
                inputController.text = await file.readAsString();
              }
            } on FormatException catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('file_not_text'.tr(namedArgs: {'name': fileName}))),
              );
            } on io.FileSystemException catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('file_not_text'.tr(namedArgs: {'name': fileName}))),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('failed_to_read_file'.tr(namedArgs: {'error': e.toString()}))),
              );
            }
          }
        },
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.clear),
        label: Text("clear".tr()),
        onPressed: () => inputController.clear(),
      ),
    ]);
  }
}
