import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/setting_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';

class ListSettings extends StatelessWidget {
  final List<SettingWidget> buttons;

  const ListSettings({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
        child: Column(
          children: List.generate(
              buttons.length,
              (index) => Column(
                    children: [
                      buttons[index],
                      (index == buttons.length - 1)
                          ? const SizedBox(height: AppDimens.widgetDimen8pt)
                          : const CustomDividerHorizontal(),
                    ],
                  )),
        ),
      ),
    );
  }
}
