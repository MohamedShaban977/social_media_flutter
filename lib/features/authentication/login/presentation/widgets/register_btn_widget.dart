import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class RegisterBtnWidget extends StatelessWidget {
  const RegisterBtnWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightGrayishBlue3,
      ),
      padding: const EdgeInsetsDirectional.only(
        top: AppDimens.customSpacing12,
        start: AppDimens.spacingLarge,
        end: AppDimens.spacingLarge,
        bottom: AppDimens.spacingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.doNotHaveAnAccount.tr(),
                style: TextStyleManager.regular(
                  size: AppDimens.textSize14pt,
                  color: AppColors.darkGrayishBlue3,
                ),
              ),
              Text(
                LocaleKeys.register.tr(),
                style: TextStyleManager.medium(
                  color: AppColors.veryDarkGrayishBlue,
                  size: AppDimens.textSize20pt,
                ),
              )
            ],
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, RoutesNames.registerRoute),
            child: Container(
              width: AppDimens.widgetDimen32pt,
              height: AppDimens.widgetDimen32pt,
              decoration: const ShapeDecoration(
                color: AppColors.lightGrayishBlue2,
                shape: OvalBorder(),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.vividCyan,
                  size: AppDimens.widgetDimen16pt,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
