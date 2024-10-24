import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/features/main_layout/presentation/widgets/tool_bar_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ToolBarWidget(
            title: LocaleKeys.chat.tr(),
            trailingWidget: CustomImage.svg(src: AppSvg.icNewChat),
          ),
        ],
      ),
    );
  }
}
