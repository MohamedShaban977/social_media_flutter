import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class CameraOptionWidget extends StatelessWidget {
  const CameraOptionWidget({super.key, required this.onOpenCameraTapped});

  final void Function()? onOpenCameraTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.customSpacing4),
      child: Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            Feedback.forTap(context);
            onOpenCameraTapped?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(AppDimens.customSpacing28),
            decoration: BoxDecoration(
              color: AppColors.lightGrayishBlue4,
              border: Border.all(
                color: AppColors.lightGrayishBlue,
                width: AppDimens.borderWidth1pt,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.contain,
              child: CustomImage.svg(
                src: AppSvg.icCameraOutline,
                height: AppDimens.widgetDimen32pt,
                width: AppDimens.widgetDimen32pt,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
