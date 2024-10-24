import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/image_shape.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderImagesWidget extends StatelessWidget {
  SliderImagesWidget({
    super.key,
    required this.images,
    this.heightSlider = 250,
    this.showIndicator = true,
    this.onPageChanged,
  });

  final List<String> images;
  final double heightSlider;
  final bool showIndicator;
  final void Function(int index)? onPageChanged;

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: AppColors.lightGrayishBlue4,
          )),
          child: CarouselSlider(
            options: CarouselOptions(
              height: heightSlider,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              reverse: false,
              scrollPhysics: const ClampingScrollPhysics(),
              onPageChanged: (index, _) {
                currentIndex.value = index;
                if (onPageChanged != null) {
                  onPageChanged!(index);
                }
              },
            ),
            items: images.isNotEmpty
                ? images
                    .map((i) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CustomImage.network(
                            src: i,
                            imageShape: ImageShape.roundedCorners,
                          ),
                        ))
                    .toList()
                : [
                    CustomImage.svg(
                      src: AppSvg.icPlaceholderHauui,
                      width: context.width,
                      fit: BoxFit.fitWidth,
                    )
                  ],
          ),
        ),
        if (showIndicator) ...[
          const SizedBox(height: AppDimens.widgetDimen8pt),
          ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, index, child) {
                return AnimatedSmoothIndicator(
                  activeIndex: index,
                  count: images.isNotEmpty ? images.length : 1,
                  duration: const Duration(milliseconds: 200),
                  effect: const ScrollingDotsEffect(
                    activeDotScale: 1.4,
                    dotHeight: AppDimens.widgetDimen4pt,
                    dotWidth: AppDimens.widgetDimen4pt,
                    spacing: AppDimens.customSpacing4,
                    activeDotColor: AppColors.veryDarkGrayishBlue,
                    dotColor: AppColors.grayishBlue,
                  ),
                );
              }),
        ]
      ],
    );
  }
}
