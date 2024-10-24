import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/image_shape.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/constants/enums/media_type.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/preview_media_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_video_thumbnail_widget.dart';

class PostDisplayMedia extends StatelessWidget {
  const PostDisplayMedia({
    super.key,
    required this.post,
    this.onLike,
    this.onSave,
    this.resetList,
    this.height = AppDimens.widgetDimen290pt,
  });

  final PostModel post;
  final void Function(int totalCount)? onLike;
  final void Function()? onSave;
  final void Function()? resetList;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ImageSlideshow(
      height: height,
      indicatorColor: AppColors.veryDarkGrayishBlue,
      children: (post.mediaAttributes ?? [])
          .map((item) => Padding(
                padding: const EdgeInsetsDirectional.only(bottom: AppDimens.spacingLarge),
                child: Consumer(
                  builder: (context, ref, child) {
                    return InkWell(
                      onTap: () {
                        ref
                            .read(PreviewMediaViewModel.mediaIndexProvider.notifier)
                            .set((post.mediaAttributes ?? []).indexOf(item));
                        ref.read(PreviewMediaViewModel.postProvider.notifier).set(post);
                        Navigator.of(context).pushNamed(
                          RoutesNames.previewMediaRoute,
                          arguments: {'post': post, 'onLike': onLike, 'onSave': onSave, 'resetList': resetList},
                        );
                      },
                      child: item.mediaType == MediaType.image

                          /// image
                          ? Uri.parse(item.mediaLink ?? "").isAbsolute

                              ///  display image url
                              ? CustomImage.network(
                                  src: item.mediaLink, imageShape: ImageShape.roundedCorners, fit: BoxFit.contain)
                              :

                              /// display image on create post.
                              CustomImage.asset(src: item.mediaLink)

                          ///   Video
                          : Uri.parse(item.mediaLink ?? "").isAbsolute

                              ///  display video url
                              ? PostVideoThumbnailWidget(media: item)

                              /// display video on create post.
                              : const SizedBox.shrink(),
                    );
                  },
                ),
              ))
          .toList(),
    );
  }
}
