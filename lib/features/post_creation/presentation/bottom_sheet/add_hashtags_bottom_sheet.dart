import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/text_editing_controller_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/main_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_field.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/list_suggested_hashtags.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:pinput/pinput.dart';

class AddHashtagsBottomSheet extends ConsumerStatefulWidget {
  const AddHashtagsBottomSheet({
    super.key,
  });

  @override
  ConsumerState<AddHashtagsBottomSheet> createState() => _AddHashtagsBottomSheetState();
}

class _AddHashtagsBottomSheetState extends ConsumerState<AddHashtagsBottomSheet> {
  late TextEditingController _hashtagsController;
  late ScrollController _scrollController;
  Timer? _searchDelayTimer;

  final _isHashtagsEmpty = ValueNotifier<bool>(
    true,
  );
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _hashtagsController = TextEditingController()
      ..addListener(
        _onSearchKeywordChanged,
      );
    _scrollController = ScrollController()
      ..addListener(() {
        _handlePagination();
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(PostCreationViewModel.suggestedHashtagsProvider);
      ref.invalidate(PostCreationViewModel.isLastSuggestedHashtagsPageProvider);
      ref.invalidate(PostCreationViewModel.suggestedHashtagsPageNumberProvider);
      _hashtagsController.text = ref.read(PostCreationViewModel.inputHashtagsProvider);
    });
  }

  @override
  void dispose() {
    _hashtagsController.dispose();
    _scrollController.dispose();
    _searchDelayTimer?.cancel();
    _isHashtagsEmpty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainBottomSheet(
      containerBorderRadius: AppDimens.cornerRadius4pt,
      title: LocaleKeys.addHashtag.tr(),
      action: Text(
        LocaleKeys.done.tr(),
        style: TextStyleManager.medium(
          size: AppDimens.textSize14pt,
          color: AppColors.darkGrayishBlue,
        ),
      ),
      onClose: _onDoneTapped,
      child: Container(
        height: context.height * 0.2,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimens.customSpacing28,
          vertical: AppDimens.spacingLarge,
        ),
        child: Column(
          children: [
            CustomTextField(
              controller: _hashtagsController,
              prefixIcon: ValueListenableBuilder(
                builder: (context, isHashtagsEmpty, child) => isHashtagsEmpty
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: AppDimens.spacingSmall,
                        ),
                        child: Text(
                          LocaleKeys.hashSymbol.tr(),
                          style: TextStyleManager.semiBold(
                            size: AppDimens.textSize14pt,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                valueListenable: _isHashtagsEmpty,
              ),
              hintText: LocaleKeys.addTags.tr(),
              hintStyle: TextStyleManager.regular(
                size: AppDimens.textSize14pt,
                color: AppColors.grayishBlue,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textInputAction: TextInputAction.done,
              shouldHideBorder: true,
              contentPadding: EdgeInsetsDirectional.zero,
              onTap: () {
                if (_hashtagsController.text.isEmpty) {
                  _hashtagsController.appendText(
                    text: LocaleKeys.hashSymbol.tr(),
                  );
                }
              },
              onTapOutside: (_) {},
            ),
            const Spacer(),
            ListSuggestedHashtags(
              hashtagsController: _hashtagsController,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  void _onDoneTapped() {
    ref.read(PostCreationViewModel.inputHashtagsProvider.notifier).update(
          (state) => state = _hashtagsController.text.isEmpty || _hashtagsController.text == LocaleKeys.hashSymbol.tr()
              ? ''
              : _hashtagsController.text.trim(),
        );
  }

  void _onSearchKeywordChanged() {
    _onTextChanged();
    final suggestedHashtagsNotifier = ref.read(
      PostCreationViewModel.suggestedHashtagsProvider.notifier,
    );
    _searchDelayTimer?.cancel();
    _searchDelayTimer = Timer(
      const Duration(
        seconds: AppConstants.searchDelayTime,
      ),
      () async {
        if (((_hashtagsController.text.isEmpty && suggestedHashtagsNotifier.keyword != null) ||
                _hashtagsController.text.isNotEmpty) &&
            suggestedHashtagsNotifier.keyword != _hashtagsController.text) {
          suggestedHashtagsNotifier.keyword = _hashtagsController.text;
          await _getSuggestedHashtags(
            suggestedHashtagsPageNumber: ApiConstants.firstPage,
            keyWord: _getSearchKeyword(),
          );
        }
      },
    );
  }

  void _onTextChanged() {
    String text = _hashtagsController.text;
    int length = _hashtagsController.text.length;
    _isHashtagsEmpty.value = text.isEmpty;
    if (length == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else if (length > 1 &&
        text[length - 1] == LocaleKeys.hashSymbol.tr() &&
        text[length - 2] == LocaleKeys.hashSymbol.tr()) {
      _hashtagsController.delete();
    } else if (length > 0 && text.endsWith(LocaleKeys.hashSpaceHashSymbols.tr())) {
      _hashtagsController.text = _hashtagsController.text.substring(
        0,
        length - 2,
      );
    } else if (text.endsWith(LocaleKeys.spaceSymbol.tr()) && _previousText.trim().length < text.length) {
      _hashtagsController.appendText(
        text: LocaleKeys.hashSymbol.tr(),
      );
    }
    _previousText = text.trim();
  }

  String _getSearchKeyword() {
    return _hashtagsController.text
        .substring(
          _hashtagsController.text.lastIndexOf(
                LocaleKeys.hashSymbol.tr(),
              ) +
              1,
        )
        .trim();
  }

  Future<void> _getSuggestedHashtags({
    int? suggestedHashtagsPageNumber,
    required String keyWord,
  }) async {
    await ref
        .read(
          PostCreationViewModel.suggestedHashtagsProvider.notifier,
        )
        .getSuggestedHashtags(
          suggestedHashtagsPageNumber: suggestedHashtagsPageNumber,
          keyWord: keyWord,
        );
  }

  void _handlePagination() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !ref.read(
          PostCreationViewModel.isLastSuggestedHashtagsPageProvider,
        )) {
      _getSuggestedHashtags(
        keyWord: _getSearchKeyword(),
      );
    }
  }
}
