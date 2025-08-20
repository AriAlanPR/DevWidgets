import 'package:dev_widgets/src/impl/widgets/io_editor/input_editor.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/output_editor.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/code_editor_wrapper.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/input_toolbar.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/output_toolbar.dart';
import 'package:dev_widgets/src/impl/widgets/multi_split_view_divider.dart';
import 'package:dev_widgets/src/impl/widgets/accordion.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class IOEditor extends StatelessWidget {
  final bool usesCodeControllers;
  final TextEditingController? inputController;
  final TextEditingController? outputController;
  final Widget? outputChild;
  final Widget? inputChild;

  ///When set to true, creates horizontal separators.
  final bool isVerticalLayout;

  final List<Area>? initialAreas;

  final bool resizable;

  final Function(String value)? inputOnChanged;
  final Function(String value)? outputOnChanged;
  
  /// When true, renders both editors within a single parent scrollable,
  /// avoiding nested ListViews.
  final bool singleScroll;

  /// When true, wraps each editor in an ExpansionTile so the user can
  /// collapse/expand Input and Output independently. Implies singleScroll.
  final bool useExpansionPanels;

  /// Initial expansion state for the Input panel when [useExpansionPanels] is true.
  final bool inputInitiallyExpanded;

  /// Initial expansion state for the Output panel when [useExpansionPanels] is true.
  final bool outputInitiallyExpanded;
  const IOEditor(
      {super.key,
      this.usesCodeControllers = true,
      this.inputController,
      this.outputController,
      this.isVerticalLayout = false,
      this.outputChild,
      this.inputChild,
      this.resizable = true,
      this.initialAreas,
      this.inputOnChanged,
      this.outputOnChanged,
      this.singleScroll = false,
      this.useExpansionPanels = false,
      this.inputInitiallyExpanded = true,
      this.outputInitiallyExpanded = true});

  @override
  Widget build(BuildContext context) {
    // Expansion/single-scroll modes
    if (useExpansionPanels || singleScroll) {
      final inputContent = inputChild ?? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (inputController != null)
            InputToolBar(
              inputController: inputController!,
              toolbarTitle: 'input',
            ),
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 280,
            child: CodeEditorWrapper(
              usesCodeControllers: usesCodeControllers,
              textEditingController: inputController,
              onChanged: inputOnChanged,
              expands: false,
            ),
          ),
        ],
      );

      final outputContent = outputChild ?? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (outputController != null)
            OutputToolbar(
              outputController: outputController!,
              toolbarTitle: 'output',
              actionButtons: null,
            ),
          Container(
            margin: const EdgeInsets.all(8.0),
            height: 280,
            child: CodeEditorWrapper(
              usesCodeControllers: usesCodeControllers,
              readOnly: true,
              textEditingController: outputController,
              onChanged: outputOnChanged,
              expands: false,
            ),
          ),
        ],
      );

      // Return a non-scrollable Column so the parent page controls scrolling.
      if (useExpansionPanels) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Accordion(
              title: 'Input',
              initiallyExpanded: inputInitiallyExpanded,
              child: inputContent,
            ),
            const SizedBox(height: 8),
            Accordion(
              title: 'Output',
              initiallyExpanded: outputInitiallyExpanded,
              child: outputContent,
            ),
          ],
        );
      }

      // Single-scroll without expansion panels: still avoid an inner ListView.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          inputContent,
          const SizedBox(height: 8),
          outputContent,
        ],
      );
    }

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(dividerThickness: 5),
      child: MultiSplitView(
        axis: isVerticalLayout ? Axis.vertical : Axis.horizontal,
        dividerBuilder: (axis, index, resizable, dragging, highlighted,
                themeData) =>
            MultiSplitViewDivider(dragging: dragging, highlighted: highlighted),
        initialAreas: initialAreas ??
            [Area(size: 0.5, min: 0.3), Area(size: 0.5, min: 0.3)],
        resizable: resizable,
        builder: (context, area) {
          final index = area.index;
          if (index == 0) {
            return InputEditor(
                inputChild: inputChild,
                inputController: inputController,
                isVerticalLayout: isVerticalLayout,
                onChanged: inputOnChanged,
                usesCodeControllers: usesCodeControllers);
          } else {
            return OutputEditor(
                outputChild: outputChild,
                outputController: outputController,
                isVerticalLayout: isVerticalLayout,
                onChanged: outputOnChanged,
                usesCodeControllers: usesCodeControllers);
          }
        },
      ),
    );
  }
}
