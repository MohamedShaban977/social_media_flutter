import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';

class AppBarEvent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarEvent(
      {super.key, required this.onActionTapped, this.onBackTapped, required this.title, required this.titleAction});

  final void Function()? onActionTapped;
  final void Function()? onBackTapped;
  final String title, titleAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: onBackTapped,
        child: const Icon(
          Icons.close,
        ),
      ),
      title: Text(
        title,
        style: TextStyleManager.semiBold(
          size: AppDimens.textSize18pt,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
          child: InkWell(
            onTap: onActionTapped,
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
                titleAction,
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
