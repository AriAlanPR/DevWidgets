import 'package:dev_widgets/src/impl/converters/json_to_sql/json_to_sql_converter_providers.dart';
import 'package:dev_widgets/src/impl/converters/json_to_sql/page/json_to_sql_converter_input.dart';
import 'package:dev_widgets/src/impl/converters/json_to_sql/page/json_to_sql_converter_options.dart';
import 'package:dev_widgets/src/impl/converters/json_to_sql/page/json_to_sql_converter_output.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JsonToSqlConverterPage extends ConsumerWidget {
  const JsonToSqlConverterPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: TabbedPage(
          tabs: [
            TabbedTab(icon: Icons.data_object, text: "input".tr()),
            TabbedTab(icon: Icons.dataset, text: "options".tr()),
            TabbedTab(icon: Icons.output, text: "output".tr()),
          ],
          views: const [
            JsonToSqlConverterInput(),
            JsonToSqlConverterOptions(),
            JsonToSqlConverterOutput()
          ],
          onTap: (int index) {
            ref.read(selectedTabProvider.notifier).state = index;
          },
        ));
  }
}

class TabbedPage extends StatelessWidget {
  final List<TabbedTab> tabs;
  final List<ConsumerWidget> views;
  final Function(int)? onTap;

  const TabbedPage({
    super.key,
    this.onTap,
    required this.tabs,
    required this.views,
  });
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // App-level tabs (icon + label)
            TabBar(
              // NOTE: updates selectedTabProvider to keep your state in sync
              onTap: onTap,
              tabs: tabs,
            ),
            Expanded(
              child: const TabBarView(
                // Keep the same widgets as before
                children: [
                  JsonToSqlConverterInput(),
                  JsonToSqlConverterOptions(),
                  JsonToSqlConverterOutput(),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

class TabbedTab extends StatelessWidget {
  final IconData icon;
  final String text;

  const TabbedTab({
    super.key,
    required this.icon,
    required this.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return Tab(icon: Icon(icon), text: text.tr());
  }  
}