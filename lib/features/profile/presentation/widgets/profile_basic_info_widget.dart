import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/profile_mode.dart';
import 'package:hauui_flutter/core/constants/enums/user_rank.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/int_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_vertical.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/profile/presentation/widgets/counter_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ProfileBasicInfoWidget extends StatelessWidget {
  final ProfileMode profileMode;
  final UserModel user;

  const ProfileBasicInfoWidget.me({
    super.key,
    required this.user,
  }) : profileMode = ProfileMode.me;

  const ProfileBasicInfoWidget.user({
    super.key,
    required this.user,
  }) : profileMode = ProfileMode.user;

  @override
  Widget build(BuildContext context) {
    final rankImage = _getRankImage(
      rankId: user.rank?.id ?? -1,
    );
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AppDimens.customSpacing4,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    bottom: rankImage == null ? AppDimens.zero : AppDimens.customSpacing12,
                  ),
                  child: CustomImage.network(
                    src: user.imageUrl,
                    width: AppDimens.widgetDimen80pt,
                    height: AppDimens.widgetDimen80pt,
                    errorPlaceholder: AppSvg.icPlaceholderUser,
                  ),
                ),
                if (rankImage != null)
                  PositionedDirectional(
                    start: AppDimens.zero,
                    end: AppDimens.zero,
                    bottom: AppDimens.zero,
                    child: CustomImage.svg(
                      src: rankImage,
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AppDimens.spacingSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.rank?.title ?? '-',
                  style: TextStyleManager.medium(
                    size: AppDimens.textSize12pt,
                    color: AppColors.darkGrayishBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimens.customSpacing4,
                  ),
                  child: InkWell(
                    onTap: () => _onShowRanksTapped(
                      context: context,
                    ),
                    child: const CustomImage.svg(
                      src: AppSvg.icQuestionMarkGreyRounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AppDimens.spacingSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name ?? '-',
                  style: TextStyleManager.medium(
                    size: AppDimens.textSize18pt,
                  ),
                ),
                if (profileMode == ProfileMode.user && (user.seeFirst ?? false))
                  const Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: AppDimens.customSpacing4,
                    ),
                    child: CustomImage.svg(
                      src: AppSvg.icStarVividPinkRoundedGrey,
                    ),
                  ),
              ],
            ),
          ),
          if (user.addressDetails != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: AppDimens.spacingNormal,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomImage.svg(
                    src: AppSvg.icLocationGrey,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppDimens.spacingSmall,
                    ),
                    child: Text(
                      user.addressDetails!,
                      style: TextStyleManager.medium(
                        size: AppDimens.textSize18pt,
                        color: AppColors.darkGrayishBlue6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CounterWidget(
                  count: user.followersCount.getCountInUnit(),
                  title: LocaleKeys.followers.tr(),
                ),
                CustomDividerVertical(
                  indent: AppDimens.customSpacing12,
                  endIndent: AppDimens.customSpacing12,
                  color: AppColors.black.withOpacity(
                    0.25,
                  ),
                ),
                CounterWidget(
                  count: user.followingsCount.getCountInUnit(),
                  title: LocaleKeys.following.tr(),
                ),
                CustomDividerVertical(
                  indent: AppDimens.customSpacing12,
                  endIndent: AppDimens.customSpacing12,
                  color: AppColors.black.withOpacity(
                    0.25,
                  ),
                ),
                CounterWidget(
                  count: user.hobbiesCount.toString(),
                  title: LocaleKeys.hobbies.tr(),
                ),
                CustomDividerVertical(
                  indent: AppDimens.customSpacing12,
                  endIndent: AppDimens.customSpacing12,
                  color: AppColors.black.withOpacity(
                    0.25,
                  ),
                ),
                CounterWidget(
                  count: user.totalRate.toString(),
                  title: LocaleKeys.rate.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onShowRanksTapped({
    required BuildContext context,
  }) =>
      Navigator.pushNamed(
        context,
        RoutesNames.ranksRoute,
        arguments: {
          'get_rank_image': ({required rankId}) => _getRankImage(
                rankId: rankId,
              ),
        },
      );

  String? _getRankImage({
    required int rankId,
  }) {
    if (rankId == UserRank.beginner.value) {
      return AppSvg.icHauuiLevelNew;
    } else if (rankId == UserRank.junior.value) {
      return AppSvg.icHauuiLeveljunior;
    } else if (rankId == UserRank.senior.value) {
      return AppSvg.icHauuiLeveSenior;
    } else if (rankId == UserRank.mentor.value) {
      return AppSvg.icHauuiLevelMentor;
    } else {
      return null;
    }
  }
}
