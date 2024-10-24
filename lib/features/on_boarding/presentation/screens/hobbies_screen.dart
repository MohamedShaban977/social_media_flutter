import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/hobbies_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/search_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_empty_state.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_outlined_button.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/cell_hobby_with_sub_hobbies.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/list_selected_hobbies.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/skeleton_list_hobbies.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'hobbies_view_model.dart';

class HobbiesScreen extends ConsumerStatefulWidget {
  const HobbiesScreen.onBoarding({
    super.key,
    required this.levelId,
  }) : hobbiesMode = HobbiesMode.onBoarding;

  const HobbiesScreen.home({
    super.key,
    required this.levelId,
  }) : hobbiesMode = HobbiesMode.home;

  const HobbiesScreen.postCreation({
    super.key,
  })  : hobbiesMode = HobbiesMode.postCreation,
        levelId = -1;

  final HobbiesMode hobbiesMode;

  final int levelId;

  @override
  ConsumerState<HobbiesScreen> createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends ConsumerState<HobbiesScreen> {
  final _scrollController = ScrollController();
  late TextEditingController _searchController;
  Timer? _searchDelayTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(
        _onSearchKeywordChanged,
      );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(
        HobbiesViewModel.hobbiesSelectedProvider.select(
          (value) => value.selectedLocalHobbiesList.clear(),
        ),
      );
      if (widget.hobbiesMode == HobbiesMode.postCreation) {
        ref.read(
          HobbiesViewModel.hobbiesSelectedProvider.select(
            (value) => value.hobbiesWithLevel[widget.levelId] = [
              ...ref.read(
                PostCreationViewModel.selectedHobbiesProvider,
              ),
            ],
          ),
        );
      }
      _getHobbiesList(pageNumber: ApiConstants.firstPage);
      _handlePagination();
      if (ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel.containsKey(widget.levelId)) {
        ref.read(HobbiesViewModel.hobbiesSelectedProvider).fillHobbiesLocalFromHobbiesWithLevel(
            ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel[widget.levelId] ?? []);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDelayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<HobbyModel>>>(
      HobbiesViewModel.getHobbiesProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => _onBackPressed(canPop),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size(AppDimens.zero, AppDimens.widgetDimen16pt),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.hobbiesMode != HobbiesMode.postCreation)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: AppDimens.spacingNormal,
                        vertical:
                            widget.hobbiesMode == HobbiesMode.onBoarding ? AppDimens.zero : AppDimens.spacingSmall),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: widget.hobbiesMode == HobbiesMode.postCreation ? AppDimens.spacingNormal : AppDimens.zero,
                      end: AppDimens.spacingNormal,
                      bottom: AppDimens.spacingNormal,
                    ),
                    child: Text(
                      widget.hobbiesMode == HobbiesMode.onBoarding
                          ? LocaleKeys.selectYourFavouriteHobbies.tr()
                          : widget.hobbiesMode == HobbiesMode.home
                              ? LocaleKeys.editYourFavouriteHobbies.tr()
                              : LocaleKeys.addHobbies.tr(),
                      overflow: TextOverflow.clip,
                      style: TextStyleManager.semiBold(
                        color: AppColors.veryDarkGrayishBlue,
                        size: AppDimens.textSize20pt,
                      ),
                    ),
                  ),
                ),
                if (widget.hobbiesMode == HobbiesMode.postCreation)
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.spacingNormal,
                      vertical: AppDimens.spacingSmall,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      child: const CustomImage.svg(
                        src: AppSvg.icCancel,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          backgroundColor: AppColors.white,
          color: AppColors.primary,
          onRefresh: () async => await _getHobbiesList(pageNumber: ApiConstants.firstPage),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: SearchWidget(
                  searchController: _searchController,
                  hintText: LocaleKeys.searchHobbies.tr(),
                  onSubmitted: _onSearchKeywordChanged,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Consumer(
                builder: (context, ref, child) {
                  final hobbiesLocalList = ref.watch(HobbiesViewModel.hobbiesSelectedProvider).selectedLocalHobbiesList;
                  return ListSelectedHobbies(
                    hobbiesList: hobbiesLocalList,
                    onDeleted: (index) => _onDeleteHobbiesFromChip(ref, index, hobby: hobbiesLocalList[index]),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen32pt),
              const CustomDividerHorizontal(),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.suggestYourHobby.tr(),
                        overflow: TextOverflow.clip,
                        style: TextStyleManager.regular(
                          color: AppColors.veryDarkDesaturatedBlue,
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, RoutesNames.suggestHobbiesRoute),
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius8pt),
                      child: const Card(
                        elevation: AppDimens.zero,
                        child: CustomImage.svg(
                          src: AppSvg.icAddWhiteSquaredVividPink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              const CustomDividerHorizontal(),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final hobbies = ref.watch(HobbiesViewModel.getHobbiesProvider);
                    return hobbies.when(
                      data: (hobbies) => hobbies.isEmpty
                          ? CustomEmptyState(
                              title: LocaleKeys.noHobbies.tr(),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: _scrollController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: hobbies.length + 1,
                              itemBuilder: (ctx, index) {
                                return (index == hobbies.length)
                                    ? ref.read(HobbiesViewModel.isLastHobbiesPageProvider)
                                        ? const SizedBox.shrink()
                                        : const Center(child: CircularProgressIndicator())
                                    : CellHobbyWithSubHobbies(
                                        hobby: hobbies[index],
                                        levelId: widget.levelId,
                                      );
                              },
                            ),
                      error: (_, error) => const SizedBox.shrink(),
                      loading: () => const SkeletonListHobbies(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: CustomOutlinedButton(
                  label: LocaleKeys.done.tr(),
                  onPressed: () => _onDonePressed(),
                  verticalPadding: AppDimens.zero,
                  height: 56.0,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed(bool canPop) {
    if (!canPop) {
      ref.read(HobbiesViewModel.hobbiesSelectedProvider.notifier).clearLocalList();
      Navigator.pop(context);
    }
  }

  void _onDeleteHobbiesFromChip(WidgetRef ref, int index, {required HobbyModel hobby}) {
    return ref
        .read(HobbiesViewModel.hobbiesSelectedProvider)
        .onDeleteHobbiesFromChip(index, widget.levelId, hobby: hobby);
  }

  void _onDonePressed() {
    ref.read(HobbiesViewModel.hobbiesSelectedProvider).convertHobbiesLocalToHobbiesWithLevel(widget.levelId);
    if (widget.hobbiesMode == HobbiesMode.postCreation) {
      if ((ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel[widget.levelId] ?? []).length <= 2) {
        ref.read(PostCreationViewModel.selectedHobbiesProvider.notifier).update(
              (state) => state = [
                ...ref.read(HobbiesViewModel.hobbiesSelectedProvider).hobbiesWithLevel[widget.levelId] ?? [],
              ],
            );
        Navigator.pop(context);
      } else {
        context.showToast(
          message: LocaleKeys.maximumOf2HobbiesCanBeAdded.tr(),
        );
        ref.read(
          HobbiesViewModel.hobbiesSelectedProvider.select(
            (value) => value.hobbiesWithLevel[widget.levelId] = [
              ...ref.read(
                PostCreationViewModel.selectedHobbiesProvider,
              ),
            ],
          ),
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onSearchKeywordChanged() async {
    final hobbiesNotifier = ref.read(
      HobbiesViewModel.getHobbiesProvider.notifier,
    );
    _searchDelayTimer?.cancel();
    _searchDelayTimer = Timer(
      const Duration(
        seconds: AppConstants.searchDelayTime,
      ),
      () async {
        if (((_searchController.text.isEmpty && hobbiesNotifier.keyword != null) ||
                _searchController.text.isNotEmpty) &&
            hobbiesNotifier.keyword != _searchController.text) {
          hobbiesNotifier.keyword = _searchController.text;
          await _getHobbiesList(
            keyword: _searchController.text.trim(),
            pageNumber: ApiConstants.firstPage,
          );
        }
      },
    );
  }

  Future<void> _getHobbiesList({
    int? pageNumber,
    String? keyword,
  }) async {
    await ref.read(HobbiesViewModel.getHobbiesProvider.notifier).getHobbiesList(
          hobbiesPageNumber: pageNumber,
          keyword: keyword,
        );
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !ref.read(HobbiesViewModel.isLastHobbiesPageProvider)) {
        _getHobbiesList(
          keyword: _searchController.text.trim(),
        );
      }
    });
  }
}
