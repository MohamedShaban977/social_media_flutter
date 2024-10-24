import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';

class MainBottomSheet extends StatelessWidget {
  final double containerBorderRadius;
  final String title;
  final Widget? action;
  final VoidCallback? onClose;
  final Widget child;

  const MainBottomSheet({
    super.key,
    this.containerBorderRadius = AppDimens.cornerRadius10pt,
    required this.title,
    this.action,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.bottomPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              containerBorderRadius,
            ),
            topRight: Radius.circular(
              containerBorderRadius,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: AppDimens.spacingNormal,
                top: AppDimens.spacingNormal,
                end: AppDimens.spacingNormal,
                bottom: AppDimens.spacingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyleManager.semiBold(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InkWell(
                    onTap: () => _onCloseTapped(
                      context: context,
                    ),
                    child: action ??
                        const Icon(
                          Icons.close,
                          color: AppColors.darkGrayishBlue,
                        ),
                  ),
                ],
              ),
            ),
            const CustomDividerHorizontal(),
            child,
          ],
        ),
      ),
    );
  }

  void _onCloseTapped({
    required BuildContext context,
  }) {
    if (onClose != null) onClose!();
    Navigator.pop(context);
  }
}
