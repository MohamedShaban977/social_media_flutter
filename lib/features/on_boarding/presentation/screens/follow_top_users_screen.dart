import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/cell_top_user.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'follow_top_users_view_model.dart';

class FollowTopUsersScreen extends ConsumerStatefulWidget {
  const FollowTopUsersScreen({super.key});

  @override
  ConsumerState<FollowTopUsersScreen> createState() => _FollowTopUsersScreenState();
}

class _FollowTopUsersScreenState extends ConsumerState<FollowTopUsersScreen> {
  final carouselController = CarouselController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(FollowTopUsersViewModel.getTopUsersProvider.notifier)
          .getTopUsers(userPageNumber: ApiConstants.firstPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<UserModel>>>(
      FollowTopUsersViewModel.getTopUsersProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.widgetDimen45pt),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
            child: LabelScreenWidget(
              title: LocaleKeys.followTopUsers.tr(),
              showLogo: false,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              final topUsersState = ref.watch(FollowTopUsersViewModel.getTopUsersProvider);

              return topUsersState.when(
                data: (users) => CarouselSlider.builder(
                  itemCount: users.length + 1,
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: context.heightBody * 0.6 /*450*/,
                    viewportFraction: 0.85,
                    enableInfiniteScroll: false,
                    reverse: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onPageChanged: (index, _) async {
                      if (index == users.length) {
                        await ref.read(FollowTopUsersViewModel.getTopUsersProvider.notifier).getTopUsers();
                      }
                    },
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return (itemIndex == users.length)
                        ? ref.read(FollowTopUsersViewModel.isLastTopUserPageProvider)
                            ? const SizedBox.shrink()
                            : const Center(child: CircularProgressIndicator())
                        : CellTopUser(
                            user: users[itemIndex],
                            indexUser: itemIndex,
                            carouselController: carouselController,
                          );
                  },
                ),
                error: (error, _) => const SizedBox.shrink(),
                loading: () => const Center(child: CustomProgressIndicator()),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
            child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(RoutesNames.mainLayoutRoute),
                child: Text(LocaleKeys.skip.tr())),
          ),
          const SizedBox(height: AppDimens.widgetDimen16pt),
        ],
      ),
    );
  }
}
