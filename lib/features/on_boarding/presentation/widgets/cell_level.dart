import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class CellLevel extends StatelessWidget {
  const CellLevel({super.key, required this.levelsModel, this.onSelectHobbiesTapped});

  final IntKeyStingValueModel levelsModel;

  final void Function()? onSelectHobbiesTapped;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.lightGrayishBlue3,
      margin: const EdgeInsets.symmetric(
        vertical: AppDimens.spacingSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingNormal,
          vertical: AppDimens.customSpacing12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  levelsModel.name.orEmpty(),
                  style: TextStyleManager.semiBold(
                    color: AppColors.veryDarkGrayishBlue,
                    size: AppDimens.textSize14pt,
                  ),
                ),
                InkWell(
                  onTap: onSelectHobbiesTapped,
                  borderRadius: BorderRadius.circular(
                    AppDimens.cornerRadius8pt,
                  ),
                  child: Card(
                    elevation: AppDimens.zero,
                    child: CustomImage.svg(
                      src: AppSvg.icAddGreySquared,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
