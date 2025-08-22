import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

// Reveal the given file in the OS file manager (Finder/Explorer)
Future<void> _revealInFileManager(String filePath) async {
  try {
    if (io.Platform.isMacOS) {
      await io.Process.run('open', ['-R', filePath]);
    } else if (io.Platform.isWindows) {
      await io.Process.run('explorer.exe', ['/select,', filePath]);
    } else if (io.Platform.isLinux) {
      // On Linux, reveal may not be supported; open the directory instead
      await io.Process.run('xdg-open', [path.dirname(filePath)]);
    }
  } catch (_) {
    // Silently ignore failures
  }
}

void downloadImage(BuildContext context, WidgetRef ref) async {
  // Guard: nothing to download
  final bytes = ref.read(outputImageProvider);
  if (bytes.isEmpty) {
    // Show non-intrusive feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('nothing_to_download'.tr())),
    );
    return;
  }

  // Ask user to choose destination directory (desktop only)
  String? targetDir = await FilePicker.platform.getDirectoryPath();
  if (targetDir == null || targetDir.isEmpty) {
    // User cancelled
    return;
  }
  final devWidgetsFolder = targetDir;
  try {
    // Ensure directory exists (should already exist, but be safe)
    await io.Directory(devWidgetsFolder).create(recursive: true);

    // Attempt capture
    final savedPath = await ref.read(screenshotControllerProvider).captureAndSave(
          devWidgetsFolder,
          pixelRatio: 2.0,
          fileName: "DevWidgetsBase64Encoder_${DateTime.now()}.png",
        );
    
    if (!context.mounted) {
      return;
    }

    final fullPath = savedPath ?? devWidgetsFolder;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('saved_image_to'.tr(namedArgs: {'path': fullPath})),
        action: SnackBarAction(
          label: 'open'.tr(),
          onPressed: () {
            _revealInFileManager(fullPath);
          },
        ),
      ),
    );
  } catch (e) {
    // Handle errors from invalid widget size or other issues gracefully
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('failed_to_save_image'.tr(namedArgs: {'error': e.toString()}))),
    );
  }
}

void uploadImage(WidgetRef ref) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image);

  if (result != null) {
    Uint8List? bytes;
    if (kIsWeb) {
      bytes = result.files.single.bytes;
    } else {
      final file = io.File(result.files.single.path!);
      bytes = await file.readAsBytes();
    }
    ref.read(outputImageProvider.notifier).state = bytes!;

    final text = const Base64Encoder().convert(bytes);

    ref.read(inputTextProvider.notifier).state = text;
  }
}

final inputTextProvider = StateProvider<String>((ref) => "");

final screenshotControllerProvider =
    Provider.autoDispose<ScreenshotController>((ref) => ScreenshotController());

final outputImageProvider = StateProvider<Uint8List>((ref) => Uint8List(0));
