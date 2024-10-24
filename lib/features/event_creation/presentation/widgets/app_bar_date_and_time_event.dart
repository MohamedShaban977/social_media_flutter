import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AppBarDateAndTimeEvent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDateAndTimeEvent({super.key, required this.onSaveTapped, this.onCloseTapped});

  final void Function()? onSaveTapped;
  final void Function()? onCloseTapped;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: onCloseTapped ?? () => Navigator.of(context).maybePop(),
        child: const Icon(
          Icons.close,
        ),
      ),
      title: Text(
        LocaleKeys.editDateAndTime.tr(),
        style: TextStyleManager.semiBold(
          size: AppDimens.textSize18pt,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
          child: InkWell(
            onTap: onSaveTapped,
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppDimens.spacingNormal,
                vertical: AppDimens.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGrayishBlue4,
                borderRadius: BorderRadius.circular(
                  AppDimens.cornerRadius6pt,
                ),
              ),
              child: Text(
                LocaleKeys.save.tr(),
                style: TextStyleManager.regular(
                  size: AppDimens.textSize14pt,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        )
      ],
      centerTitle: false,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(AppDimens.zero),
        child: CustomDividerHorizontal(
          thickness: AppDimens.dividerThickness0Point5pt,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
