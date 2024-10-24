import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/post_creation/presentation/bottom_sheet/add_hashtags_bottom_sheet.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AddHashtagsWidget extends StatelessWidget {
  const AddHashtagsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomImage.svg(src: AppSvg.icHashtagCircular),
        const SizedBox(width: AppDimens.widgetDimen12pt),
        Text(
          LocaleKeys.addHashtags.tr(),
          style: TextStyleManager.medium(
            size: AppDimens.textSize14pt,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () => _onHashtagTapped(),
          child: const CustomImage.svg(
            src: AppSvg.icAddSquared,
            width: AppDimens.widgetDimen24pt,
            height: AppDimens.widgetDimen24pt,
          ),
        ),
      ],
    );
  }

  void _onHashtagTapped() {
    navigatorKey.currentContext!.showBottomSheet(
      widget: const AddHashtagsBottomSheet(),
    );
  }
}
