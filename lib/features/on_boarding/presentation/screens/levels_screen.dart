import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/user_hobbies_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/hobbies_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/hobbies_view_model.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/levels_view_model.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/cell_level.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/list_selected_hobbies.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/skeleton_hobby_chips.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/skeleton_levels_card.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class LevelsScreen extends ConsumerStatefulWidget {
  const LevelsScreen.add({
    super.key,
    this.openWithDrawer = false,
  }) : isEditing = false;

  const LevelsScreen.edit({
    super.key,
    this.openWithDrawer = false,
  }) : isEditing = true;

  final bool openWithDrawer;
  final bool isEditing;

  @override
  ConsumerState<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends ConsumerState<LevelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(LevelsViewModel.getLevelsProvider.notifier).getLevelsList();

      ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel.clear();
      if (UserExtensions.getCachedUser() != null && widget.isEditing) {
        await ref.read(HobbiesViewModel.getUserHobbiesProvider.notifier).getUserHobbies();
        _handleFillHobbiesWithLevelInEditUser();
      }
    });
  }

  void _handleFillHobbiesWithLevelInEditUser() {
    final userHobbiesState = ref.read(HobbiesViewModel.getUserHobbiesProvider);

    if (userHobbiesState.hasValue && userHobbiesState.value != null) {
      ref.read(HobbiesViewModel.hobbiesSelectedProvider.notifier).fillHobbiesWithLevelInEditUser(
            userHobbiesState.value!,
          );
    }
  }

  final ValueNotifier<int> _levelId = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<IntKeyStingValueModel>>>(
      LevelsViewModel.getLevelsProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    return SizedBox(
      width: widget.openWithDrawer ? context.width * 0.85 : null,
      child: Scaffold(
        appBar: widget.openWithDrawer
            ? null
            : AppBar(
                leading: Navigator.canPop(context)
                    ? InkWell(
                        onTap: () {
                          ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel.clear();
                          Navigator.maybePop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      )
                    : null,
                automaticallyImplyLeading: false, // hide hamburger icon
              ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: widget.openWithDrawer
            ? SizedBox(
                width: context.width * 0.85,
                child: ValueListenableBuilder(
                  builder: (context, isVisible, child) {
                    return widget.openWithDrawer
                        ? HobbiesScreen.home(
                            levelId: _levelId.value,
                          )
                        : HobbiesScreen.onBoarding(
                            levelId: _levelId.value,
                          );
                  },
                  valueListenable: _levelId,
                ))
            : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              if (widget.openWithDrawer) ...[
                const SizedBox(height: AppDimens.widgetDimen16pt),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        LocaleKeys.editYourFavouriteHobbies.tr(),
                        overflow: TextOverflow.clip,
                        style: TextStyleManager.semiBold(
                          color: AppColors.veryDarkGrayishBlue,
                          size: AppDimens.textSize20pt,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: AppDimens.spacingSmall),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CustomImage.svg(src: AppSvg.icCancel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.widgetDimen45pt),
              ] else ...[
                const SizedBox(height: AppDimens.widgetDimen45pt),
                Text(
                  LocaleKeys.selectFavouriteHobbies.tr(),
                  style: TextStyleManager.semiBold(
                    color: AppColors.veryDarkGrayishBlue,
                    size: AppDimens.textSize20pt,
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.widgetDimen24pt),
              Consumer(
                builder: (context, ref, child) {
                  final levels = ref.watch(LevelsViewModel.getLevelsProvider);

                  return levels.when(
                      data: (levels) => Column(
                            children: List.generate(
                                levels.length,
                                (index) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CellLevel(
                                          levelsModel: levels[index],
                                          onSelectHobbiesTapped: () async => _onLevelTapped(context, levels[index]),
                                        ),
                                        Consumer(
                                          builder: (context, ref, child) {
                                            final hobbies = ref
                                                .watch(HobbiesViewModel.hobbiesSelectedProvider)
                                                .hobbiesWithLevel[levels[index].id];
                                            final userHobbiesState = ref.watch(HobbiesViewModel.getUserHobbiesProvider);
                                            if (userHobbiesState.isLoading) {
                                              return const SkeletonHobbyChips();
                                            }
                                            return ListSelectedHobbies(
                                              hobbiesList: hobbies ?? [],
                                              onDeleted: (indexHobby) =>
                                                  _onDeletedChipHobbies(ref, indexHobby, levels[index]),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                          ),
                      error: (_, error) => const SizedBox.shrink(),
                      loading: () => const SkeletonLevelsCard());
                },
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Consumer(
            builder: (context, ref, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
                child: Center(
                  child: CustomButtonWithLoading(
                      isDisabled: ref.watch(HobbiesViewModel.hobbiesSelectedProvider).isDisabledButton,
                      onPressed: () async => await _onDonePressed(ref),
                      title: LocaleKeys.done.tr()),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _onDeletedChipHobbies(WidgetRef ref, int indexHobby, IntKeyStingValueModel level) {
    ref.read(HobbiesViewModel.hobbiesSelectedProvider).onDeleteHobbiesFromChip(indexHobby, level.id!);
  }

  void _onLevelTapped(context, IntKeyStingValueModel level) {
    if (widget.openWithDrawer) {
      _levelId.value = level.id!;
      Scaffold.of(context).openEndDrawer();
    } else {
      HobbiesViewModel.navigateToSelectHobbiesScreen(level.id!);
    }
  }

  Future<void> _onDonePressed(WidgetRef ref) async {
    await ref.read(HobbiesViewModel.addUserHobbiesProvider.notifier).addUserHobbies(UserHobbiesRequestBody(
          userHobbies: ref.read(HobbiesViewModel.hobbiesSelectedProvider).userHobbies,
        ));
    final addedUserHobbiesState = ref.read(HobbiesViewModel.addUserHobbiesProvider);

    if (addedUserHobbiesState.hasValue && addedUserHobbiesState.value?.data != null) {
      navigatorKey.currentContext!.showToast(message: addedUserHobbiesState.value?.data ?? '');
      if (widget.openWithDrawer || widget.isEditing) {
        Navigator.pop(navigatorKey.currentContext!);
      } else {
        Navigator.of(navigatorKey.currentContext!).pushNamed(RoutesNames.countriesAndCitiesRoute);
      }
    } else {
      navigatorKey.currentContext!.showToast(message: addedUserHobbiesState.error.toString());
    }
  }
}
