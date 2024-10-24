import 'package:flutter/cupertino.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/login/data/models/rank_model.dart';

class CellRank extends StatelessWidget {
  final RankModel rank;
  final String? rankImage;

  const CellRank({
    super.key,
    required this.rank,
    required this.rankImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                end: AppDimens.spacingSmall,
              ),
              child: CustomImage.svg(
                src: rankImage,
              ),
            ),
            Text(
              rank.title ?? '-',
              style: TextStyleManager.medium(
                size: AppDimens.textSize18pt,
                color: AppColors.black,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: AppDimens.spacingSmall,
          ),
          child: Text(
            rank.notes ?? '-',
            style: TextStyleManager.regular(
              size: AppDimens.textSize14pt,
              color: AppColors.darkGrayishBlue,
            ),
          ),
        )
      ],
    );
  }
}
