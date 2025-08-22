import 'package:code_text_field/code_text_field.dart';
import 'package:dev_widgets/src/impl/settings/settings_provider.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeEditorWrapper extends ConsumerWidget {
  final TextEditingController? textEditingController;
  final bool usesCodeControllers;
  final bool readOnly;
  final Function(String value)? onChanged;
  final int? minLines;
  final bool expands;
  const CodeEditorWrapper(
      {super.key,
      required this.usesCodeControllers,
      this.textEditingController,
      this.onChanged,
      this.minLines = 10,
      this.readOnly = false,
      this.expands = true});

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(settingsProvider);

    if (usesCodeControllers) {
      // Build a shared text style to ensure code and line numbers have identical
      // font metrics (height/baseline), preventing vertical misalignment.
      final codeStyle = TextStyle(
        fontFamily: settings.textEditorFontFamily,
        fontSize: settings.textEditorFontSize,
        color: Theme.of(context).textTheme.bodyMedium!.color,
        inherit: false,
        textBaseline: TextBaseline.alphabetic,
        height: 1.3, // enforce consistent line height
      );

      // Use provided controller or a temporary one for rendering. We read the
      // current line count to size the gutter so line numbers don't wrap.
      final codeController =
          (textEditingController ?? CodeController()) as CodeController;

      // Measure required width using TextPainter to avoid wrapping/clipping.
      final lineCount = codeController.text.split('\n').length;
      final digitCount = lineCount.toString().length;
      final reservedDigits = digitCount < 4 ? 4 : digitCount; // allow up to 9999
      final sampleText = '8' * reservedDigits; // widest digit in most fonts
      final painter = TextPainter(
        text: TextSpan(text: sampleText, style: codeStyle),
        maxLines: 1,
        textDirection: Directionality.of(context),
      )..layout();
      final measured = painter.size.width;
      final gutterWidth = measured + 24; // padding for breathing room

      return CodeTheme(
        data:
            CodeThemeData(styles: textEditorThemes[settings.textEditorTheme]!),
        child: CodeField(
          wrap: settings.textEditorWrap,
          lineNumbers: settings.textEditorDisplayLineNumbers,
          textStyle: codeStyle,
          isDense: true,
          lineNumberStyle: LineNumberStyle(
            // same metrics as code text to align baselines
            textStyle: codeStyle,
            width: gutterWidth,
            textAlign: TextAlign.right,
            margin: 8,
          ),
          readOnly: readOnly,
          expands: expands,
          onChanged: onChanged,
          controller: codeController,
        ),
      );
    } else {
      return TextFormField(
        maxLines: settings.textEditorWrap ? null : (minLines! + 1),
        style: TextStyle(
            fontFamily: settings.textEditorFontFamily,
            fontSize: settings.textEditorFontSize,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            inherit: false,
            textBaseline: TextBaseline.alphabetic),
        minLines: minLines,
        enabled: true,
        controller: textEditingController ?? TextEditingController(),
        onChanged: onChanged,
        keyboardType: TextInputType.multiline,
      );
    }
  }
}
