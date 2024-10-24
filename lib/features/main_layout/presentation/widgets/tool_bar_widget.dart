import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';

class ToolBarWidget extends ConsumerWidget {
  const ToolBarWidget({super.key, this.showAppLogo = false, required this.title, this.trailingWidget});

  final bool showAppLogo;
  final String title;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: AppDimens.toolBarHeight70pt,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.customSpacing12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (showAppLogo)
                const Padding(
                  padding: EdgeInsetsDirectional.only(end: AppDimens.spacingSmall),
                  child: CustomImage.svg(
                    src: AppSvg.icLogoHauui,
                    width: AppDimens.widgetDimen24pt,
                    height: AppDimens.widgetDimen16pt,
                  ),
                ),
              Text(
                title,
                style: TextStyleManager.semiBold(size: AppDimens.textSize22pt),
              )
            ],
          ),
          trailingWidget ??
              Wrap(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final accountMode = ref.read(AccountViewModel.accountModeProvider);

                      return InkWell(
                        onTap: () => (accountMode == AccountMode.authorized)
                            ? navigatorKey.currentState?.pushNamed(RoutesNames.notificationsRoute)
                            : context.showBottomSheet(widget: const LayoutLoginWithBottomSheet()),
                        child: const CustomImage.svg(src: AppSvg.icNotification),
                      );
                    },
                  ),
                  const SizedBox(width: AppDimens.spacingLarge),
                  InkWell(
                    onTap: () => navigatorKey.currentState?.pushNamed(RoutesNames.searchRoute),
                    child: const CustomImage.svg(src: AppSvg.icSearch),
                  ),
                  const SizedBox(width: AppDimens.spacingLarge),
                  Consumer(
                    builder: (context, ref, child) {
                      final accountMode = ref.read(AccountViewModel.accountModeProvider);

                      return InkWell(
                        onTap: () => (accountMode == AccountMode.authorized)
                            ? navigatorKey.currentState?.pushNamed(
                      RoutesNames.myProfileRoute,
                    )
                            : context.showBottomSheet(widget: const LayoutLoginWithBottomSheet()),
                        child: const CustomImage.svg(src: AppSvg.icProfile),
                      );
                    },
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
