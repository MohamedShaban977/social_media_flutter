import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/screens/login_screen.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class LayoutLoginWithBottomSheet extends StatelessWidget {
  const LayoutLoginWithBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height - (MediaQueryData.fromView(View.of(context)).padding.top),
      width: double.infinity,
      color: AppColors.transparent,
      child: Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.cornerRadius12pt),
                topRight: Radius.circular(AppDimens.cornerRadius12pt),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: CustomImage.svg(src: AppSvg.icCancel),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: LoginScreen()),
            ],
          )),
    );
  }
}
