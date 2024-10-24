import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_outlined_button.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/follow_top_users_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class CellJoiner extends StatelessWidget {
  const CellJoiner({super.key, required this.joiner, required this.index});

  final UserModel joiner;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
      child: Row(
        children: [
          CustomImage.network(
            src: joiner.imageUrl,
            width: AppDimens.widgetDimen48pt,
            height: AppDimens.widgetDimen48pt,
            errorIconSize: AppDimens.widgetDimen45pt,
          ),
          const SizedBox(width: AppDimens.widgetDimen16pt),
          Expanded(
            child: Text(
              joiner.name ?? '-',
              style: TextStyleManager.regular(),
            ),
          ),

          /// follow or unfollow button
          Consumer(
            builder: (context, ref, child) {
              final followState = ref.watch(FollowTopUsersViewModel.followUserProvider);
              final unfollowState = ref.watch(FollowTopUsersViewModel.unfollowUserProvider);
              final currentIndex = ref.watch(EventsViewModel.currentIndexJoinerProvider);

              return CustomOutlinedButton(
                foregroundColor: (joiner.isFollowed ?? false) ? null : AppColors.white,
                backgroundColor: (joiner.isFollowed ?? false) ? null : AppColors.primary,
                borderRadius: AppDimens.cornerRadius10pt,
                height: AppDimens.widgetDimen16pt,
                width: AppDimens.widgetDimen80pt,
                borderColor: (joiner.isFollowed ?? false) ? AppColors.veryDarkDesaturatedBlue : AppColors.transparent,
                borderWidth: (joiner.isFollowed ?? false) ? AppDimens.borderWidth1pt : AppDimens.zero,
                horizontalPadding: AppDimens.zero,
                verticalPadding: AppDimens.zero,
                onPressed: () => (followState.isLoading || unfollowState.isLoading)
                    ? null
                    : _onFollowOrUnfollowPressed(ref, index, joiner),
                child: ((followState.isLoading || unfollowState.isLoading) && index == currentIndex)
                    ? CustomProgressIndicator(color: (joiner.isFollowed ?? false) ? AppColors.primary : AppColors.white)
                    : Text((joiner.isFollowed ?? false) ? LocaleKeys.unfollow.tr() : LocaleKeys.follow.tr()),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onFollowOrUnfollowPressed(WidgetRef ref, int index, UserModel joiner) async {
    if (joiner.isFollowed ?? false) {
      await _onFollowPressed(ref, index, joiner);
    } else {
      await _onUnfollowPressed(ref, index, joiner);
    }
  }

  Future<void> _onUnfollowPressed(WidgetRef ref, int index, UserModel joiner) async {
    ref.read(EventsViewModel.currentIndexJoinerProvider.notifier).update((state) => state = index);

    await ref.read(FollowTopUsersViewModel.followUserProvider.notifier).followUser(joiner.id!);

    final followState = ref.read(FollowTopUsersViewModel.followUserProvider);
    if (followState.hasValue && followState.value != null) {
      ref.read(EventsViewModel.eventDetailsProvider.notifier).updateFollowingUser(index, true);
    }
    if (followState.hasError) {
      navigatorKey.currentContext!.showToast(message: followState.error.toString());
    }
  }

  Future<void> _onFollowPressed(WidgetRef ref, int index, UserModel joiner) async {
    ref.read(EventsViewModel.currentIndexJoinerProvider.notifier).update((state) => state = index);

    await ref.read(FollowTopUsersViewModel.unfollowUserProvider.notifier).unfollowUser(joiner.id!);
    final unfollowState = ref.read(FollowTopUsersViewModel.unfollowUserProvider);

    if (unfollowState.hasValue && unfollowState.value != null) {
      ref.read(EventsViewModel.eventDetailsProvider.notifier).updateFollowingUser(index, false);
    }
    if (unfollowState.hasError) {
      navigatorKey.currentContext!.showToast(message: unfollowState.error.toString());
    }
  }
}
