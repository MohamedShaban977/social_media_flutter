import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/features/main_layout/presentation/widgets/tool_bar_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ToolBarWidget(
            title: LocaleKeys.map.tr(),
          ),
        ],
      ),
    );
  }
}
