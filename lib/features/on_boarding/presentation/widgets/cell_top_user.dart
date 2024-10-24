import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_outlined_button.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/follow_top_users_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'cell_statistic_top_user.dart';

class CellTopUser extends StatelessWidget {
  final UserModel user;
  final int indexUser;
  final CarouselController carouselController;

  const CellTopUser({super.key, required this.user, required this.carouselController, required this.indexUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimens.zero,
      color: AppColors.lightGrayishBlue4,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: AppDimens.widgetDimen32pt),

            /// image user url
            Container(
              width: AppDimens.widgetDimen155pt,
              height: AppDimens.widgetDimen155pt,
              decoration: const ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                    width: AppDimens.borderWidth1pt,
                    color: AppColors.grayishBlue,
                  ),
                ),
              ),
              child: CustomImage.network(
                src: user.imageUrl,
              ),
            ),
            const SizedBox(height: AppDimens.widgetDimen12pt),

            /// name user
            Text(
              user.name ?? '',
              style: TextStyleManager.semiBold(
                color: AppColors.veryDarkGrayishBlue,
                size: AppDimens.textSize20pt,
              ),
            ),
            const SizedBox(height: AppDimens.widgetDimen4pt),

            /// address details
            Text(
              user.addressDetails ?? '-',
              style: TextStyleManager.semiBold(
                color: AppColors.darkGrayishBlue,
                size: AppDimens.textSize14pt,
              ),
            ),
            const SizedBox(height: AppDimens.widgetDimen12pt),

            /// follow or unfollow button
            Consumer(
              builder: (context, ref, child) {
                final followState = ref.watch(FollowTopUsersViewModel.followUserProvider);
                final unfollowState = ref.watch(FollowTopUsersViewModel.unfollowUserProvider);

                return CustomOutlinedButton(
                  foregroundColor: (user.isFollowed ?? false) ? null : AppColors.white,
                  backgroundColor: (user.isFollowed ?? false) ? null : AppColors.primary,
                  borderRadius: AppDimens.cornerRadius10pt,
                  height: AppDimens.widgetDimen45pt,
                  width: AppDimens.widgetDimen155pt,
                  borderColor: (user.isFollowed ?? false) ? AppColors.veryDarkDesaturatedBlue : AppColors.transparent,
                  borderWidth: (user.isFollowed ?? false) ? AppDimens.borderWidth1pt : AppDimens.zero,
                  horizontalPadding: AppDimens.zero,
                  verticalPadding: AppDimens.zero,
                  onPressed: () => (followState.isLoading || unfollowState.isLoading)
                      ? null
                      : _onFollowOrUnfollowPressed(ref, user, indexUser),
                  child: (followState.isLoading || unfollowState.isLoading)
                      ? CustomProgressIndicator(color: (user.isFollowed ?? false) ? AppColors.primary : AppColors.white)
                      : Text((user.isFollowed ?? false) ? LocaleKeys.unfollow.tr() : LocaleKeys.follow.tr()),
                );
              },
            ),
            const SizedBox(height: AppDimens.widgetDimen24pt),
            const CustomDividerHorizontal(),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///followers
                  CellStatisticTopUser(
                    title: LocaleKeys.followers.tr(),
                    value: user.followersCount.toString(),
                  ),

                  ///following
                  CellStatisticTopUser(
                    title: LocaleKeys.following.tr(),
                    value: user.followingsCount.toString(),
                  ),

                  ///Hobbies
                  CellStatisticTopUser(
                    title: LocaleKeys.hobbies.tr(),
                    value: user.hobbiesCount.toString(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onFollowOrUnfollowPressed(WidgetRef ref, UserModel user, int indexUser) async {
    if (user.isFollowed ?? false) {
      await _onFollowPressed(ref, user, indexUser);
    } else {
      await _onUnfollowPressed(ref, user, indexUser);
    }
    carouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  Future<void> _onUnfollowPressed(WidgetRef ref, UserModel user, int indexUser) async {
    await ref.read(FollowTopUsersViewModel.followUserProvider.notifier).followUser(user.id!);

    final followState = ref.read(FollowTopUsersViewModel.followUserProvider);

    if (followState.hasValue && followState.value != null) {
      ref.read(FollowTopUsersViewModel.getTopUsersProvider.notifier).updateFollowingUser(indexUser, true);
    }
    if (followState.hasError) {
      navigatorKey.currentContext!.showToast(message: followState.error.toString());
    }
  }

  Future<void> _onFollowPressed(WidgetRef ref, UserModel user, int indexUser) async {
    await ref.read(FollowTopUsersViewModel.unfollowUserProvider.notifier).unfollowUser(user.id!);
    final unfollowState = ref.read(FollowTopUsersViewModel.unfollowUserProvider);

    if (unfollowState.hasValue && unfollowState.value != null) {
      ref.read(FollowTopUsersViewModel.getTopUsersProvider.notifier).updateFollowingUser(indexUser, false);
    }
    if (unfollowState.hasError) {
      navigatorKey.currentContext!.showToast(message: unfollowState.error.toString());
    }
  }
}
