import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/file_type.dart';
import 'package:hauui_flutter/core/models/file_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class CellThumbnail extends StatelessWidget {
  const CellThumbnail({
    super.key,
    this.fileMedia,
    this.onDeleteTapped,
    this.url,
  });

  final FileModel? fileMedia;
  final void Function()? onDeleteTapped;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: AppDimens.widgetDimen59pt,
          width: AppDimens.widgetDimen59pt,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius6pt),
            border: Border.all(
              color: AppColors.grayishBlue,
              width: AppDimens.borderWidth1pt,
            ),
          ),
          child: (url != null)
              ? CustomImage.network(
                  src: url!,
                  fit: BoxFit.fill,
                  height: AppDimens.widgetDimen59pt,
                  width: AppDimens.widgetDimen59pt,
                )
              : (fileMedia?.fileType == FileType.image)
                  ? Image.file(
                      fileMedia!.pickedFile!,
                      fit: BoxFit.fill,
                      height: AppDimens.widgetDimen59pt,
                      width: AppDimens.widgetDimen59pt,
                    )
                  : (fileMedia?.fileType == FileType.video)
                      ? Image.memory(
                          fileMedia!.thumbnail!,
                          fit: BoxFit.fill,
                          height: AppDimens.widgetDimen59pt,
                          width: AppDimens.widgetDimen59pt,
                        )
                      : const SizedBox.shrink(),
        ),
        PositionedDirectional(
          end: (fileMedia?.fileType == FileType.image) ? -AppDimens.customSpacing4 : AppDimens.zero,
          top: (fileMedia?.fileType == FileType.image) ? -AppDimens.customSpacing4 : AppDimens.zero,
          bottom: (fileMedia?.fileType == FileType.video) ? AppDimens.zero : null,
          start: (fileMedia?.fileType == FileType.video) ? AppDimens.zero : null,
          child: Center(
            child: InkWell(
              onTap: onDeleteTapped,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red,
                ),
                padding: const EdgeInsets.all(AppDimens.customSpacing4),
                child: const CustomImage.svg(
                  src: AppSvg.icCancel,
                  color: AppColors.white,
                  height: AppDimens.widgetDimen8pt,
                  width: AppDimens.widgetDimen8pt,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
