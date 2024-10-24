import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/main_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/main_activity_creation/data/models/creation_item_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class CreationBottomSheet extends StatelessWidget {
  CreationBottomSheet({super.key});

  final creationItems = [
    CreationItemModel(
      image: AppSvg.icLive,
      title: LocaleKeys.goLive.tr(),
      onTap: () {},
    ),
    CreationItemModel(
      image: AppSvg.icPost,
      title: LocaleKeys.post.tr(),
      onTap: () => Navigator.pushNamed(
        navigatorKey.currentContext!,
        RoutesNames.createPostRoute,
      ),
    ),
    CreationItemModel(
      image: AppSvg.icEvent,
      title: LocaleKeys.event.tr(),
      onTap: () => Navigator.pushNamed(
        navigatorKey.currentContext!,
        RoutesNames.addEventRoute,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainBottomSheet(
      title: LocaleKeys.create.tr(),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.spacing5XLarge, vertical: AppDimens.customSpacing20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: creationItems
              .map(
                (item) => InkWell(
                  onTap: () => item.onTap(),
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CustomImage.svg(src: item.image),
                      const SizedBox(height: AppDimens.widgetDimen16pt),
                      Text(
                        item.title,
                        style: TextStyleManager.semiBold(size: AppDimens.textSize12pt),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
