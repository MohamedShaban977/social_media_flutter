import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/image_shape.dart';
import 'package:hauui_flutter/core/constants/enums/video_type.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/vimeo_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PostVideoThumbnailWidget extends ConsumerStatefulWidget {
  const PostVideoThumbnailWidget({
    super.key,
    required this.media,
    this.height = AppDimens.widgetDimen290pt,
  });
  final MediaModel media;
  final double height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostVideoThumbnailWidgetState();
}

class _PostVideoThumbnailWidgetState extends ConsumerState<PostVideoThumbnailWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.veryDarkDesaturatedBlue,
          height: widget.height,
          width: MediaQuery.of(context).size.width,
          child:
              widget.media.type == VideoType.mp4 && !((widget.media.mediaLink ?? "").contains(AppConstants.googleDrive))
                  ? FutureBuilder(
                      future: widget.media.mp4ThumbnailPath,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        return Image.file(File(widget.media.thumbnail ?? ""));
                      })
                  : widget.media.type == VideoType.vimeo
                      ? FutureBuilder(
                          future: getVimeoThumbnailPath(ref),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                            widget.media.thumbnail = snapshot.data;
                            return CustomImage.network(
                              src: snapshot.data,
                              imageShape: ImageShape.roundedCorners,
                            );
                          })
                      : CustomImage.network(src: widget.media.thumbnail, imageShape: ImageShape.roundedCorners),
        ),
        PositionedDirectional(
          end: AppDimens.spacingNormal,
          bottom: AppDimens.spacingNormal,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CustomImage.svg(src: AppSvg.icLogoHauuiWhite, width: AppDimens.widgetDimen16pt),
              const SizedBox(width: AppDimens.widgetDimen8pt),
              Text(
                LocaleKeys.appName.tr(),
                style: TextStyleManager.black(size: AppDimens.textSize10pt, color: AppColors.white),
              ),
            ],
          ),
        ),
        const Center(
          child: Icon(
            Icons.play_circle_outline_rounded,
            color: AppColors.white,
            size: AppDimens.widgetDimen48pt,
            shadows: [Shadow(color: AppColors.darkGray, blurRadius: AppDimens.blurRadius3pt)],
          ),
        ),
      ],
    );
  }

  Future<String> getVimeoThumbnailPath(WidgetRef ref) async {
    final videoId = (widget.media.mediaLink ?? "").split('/').last;
    await ref.read(VimeoViewModel.vimeoProvider.notifier).getVimeoThumbnail(videoId: videoId);
    return ref.read(VimeoViewModel.vimeoProvider).value ?? "";
  }
}
