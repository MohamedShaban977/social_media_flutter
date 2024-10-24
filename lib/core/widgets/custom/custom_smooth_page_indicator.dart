import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/constants/enums/smooth_page_indicator_effect.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  final int count;
  final PageController pageController;
  final SmoothPageIndicatorEffect smoothPageIndicatorEffect;

  const CustomSmoothPageIndicator({
    super.key,
    required this.count,
    required this.pageController,
    this.smoothPageIndicatorEffect = SmoothPageIndicatorEffect.jumpingDot,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmoothPageIndicator(
        controller: pageController, // PageController
        count: count,
        effect: smoothPageIndicatorEffect == SmoothPageIndicatorEffect.jumpingDot
            ? const JumpingDotEffect(
                dotWidth: AppDimens.smoothPageIndicatorDotDimen4pt,
                dotHeight: AppDimens.smoothPageIndicatorDotDimen4pt,
                activeDotColor: AppColors.veryDarkGrayishBlue,
                dotColor: AppColors.grayishBlue,
                spacing: AppDimens.customSpacing4,
              )
            : const ExpandingDotsEffect(
                dotWidth: AppDimens.smoothPageIndicatorDotDimen4pt,
                dotHeight: AppDimens.smoothPageIndicatorDotDimen4pt,
                activeDotColor: AppColors.veryDarkGrayishBlue,
                dotColor: AppColors.grayishBlue,
                spacing: AppDimens.spacingSmall,
                expansionFactor: 3.5,
              ), // your preferred effect
        onDotClicked: (index) {},
      ),
    );
  }
}
