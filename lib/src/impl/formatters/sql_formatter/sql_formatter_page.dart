import 'package:dev_widgets/src/impl/formatters/sql_formatter/sql_dialect.dart';
import 'package:dev_widgets/src/impl/formatters/sql_formatter/sql_formatter_providers.dart';
import 'package:dev_widgets/src/impl/helpers.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/code_controller_hook.dart';
import 'package:dev_widgets/src/impl/widgets/io_editor/io_editor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:highlight/languages/sql.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaru/yaru.dart';

class SqlFormatterPage extends HookConsumerWidget {
  const SqlFormatterPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final inputController = useCodeController(language: sql);
    final outputController = useCodeController(language: sql);

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
        try {
          outputController.text = ref.watch(outputTextProvider);
        } catch (_) {
          //Bug on text_code_field package.
        }
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
                      Icons.code,
                      size: 25,
                    ),
                    title: Text("dialect".tr()),
                    trailing: DropdownButton<SqlDialect>(
                      value: ref.watch(sqlDialectProvider),
                      items:
                          getDropdownMenuItems<SqlDialect>(SqlDialect.values),
                      onChanged: (selected) => ref
                          .read(sqlDialectProvider.notifier)
                          .state = selected!,
                    ),
                  ),
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
