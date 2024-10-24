import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/constants/enums/image_shape.dart';
import '/core/constants/enums/image_type.dart';
import 'custom_progress_indicator.dart';

class CustomImage extends StatelessWidget {
  final ImageType imageType;
  final String? src;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final bool? isMatchingTextDirection;
  final ImageShape? imageShape;
  final double? radius;
  final String? errorPlaceholder;
  final double? errorPlaceholderWidth;
  final double? errorPlaceholderHeight;
  final BoxFit? errorPlaceholderFit;
  final double? errorIconSize;

  const CustomImage.asset({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
  })  : imageType = ImageType.asset,
        isMatchingTextDirection = null,
        imageShape = null,
        radius = null,
        errorPlaceholder = null,
        errorPlaceholderWidth = null,
        errorPlaceholderHeight = null,
        errorPlaceholderFit = null,
        errorIconSize = null;

  const CustomImage.svg({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.isMatchingTextDirection = true,
  })  : imageType = ImageType.svg,
        imageShape = null,
        radius = null,
        errorPlaceholder = null,
        errorPlaceholderWidth = null,
        errorPlaceholderHeight = null,
        errorPlaceholderFit = null,
        errorIconSize = null;

  const CustomImage.network({
    super.key,
    this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.imageShape = ImageShape.circular,
    this.radius = 0,
    this.errorPlaceholder,
    this.errorPlaceholderWidth,
    this.errorPlaceholderHeight,
    this.errorPlaceholderFit = BoxFit.contain,
    this.errorIconSize = AppDimens.widgetDimen100pt,
  })  : imageType = ImageType.network,
        color = null,
        isMatchingTextDirection = null;

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case ImageType.asset:
        return Image.asset(
          src!,
          width: width,
          height: height,
          color: color,
          fit: fit,
        );
      case ImageType.svg:
        return SvgPicture.asset(
          src!,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                )
              : null,
          matchTextDirection: isMatchingTextDirection!,
        );
      default:
        var child = Image.network(
          src ?? '',
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CustomProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) => errorPlaceholder != null
              ? SvgPicture.asset(
                  errorPlaceholder!,
                  width: errorPlaceholderWidth ?? width,
                  height: errorPlaceholderHeight ?? height,
                  fit: errorPlaceholderFit!,
                )
              : Icon(
                  Icons.image_not_supported,
                  color: AppColors.grayishOrange,
                  size: errorIconSize,
                ),
        );
        return imageShape == ImageShape.circular
            ? ClipOval(
                child: child,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(
                  radius!,
                ),
                child: child,
              );
    }
  }
}
