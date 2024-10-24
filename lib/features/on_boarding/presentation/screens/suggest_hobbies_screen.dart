import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/suggest_hobby_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/widgets/suggest_auto_complete_input_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'suggest_hobbies_view_model.dart';

class SuggestHobbiesScreen extends ConsumerStatefulWidget {
  const SuggestHobbiesScreen({super.key});

  @override
  ConsumerState<SuggestHobbiesScreen> createState() => _SuggestHobbiesScreenState();
}

class _SuggestHobbiesScreenState extends ConsumerState<SuggestHobbiesScreen> {
  final _hobbyController = TextEditingController();
  final _subHobbyController = TextEditingController();
  final _suggestionsHobbyController = SuggestionsController<HobbyModel>();
  final _suggestionsSubHobbyController = SuggestionsController<HobbyModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(SuggestHobbiesViewModel.getSuggestHobbiesProvider.notifier).clearSuggestHobbies();
      ref.read(SuggestHobbiesViewModel.getSuggestSubHobbiesProvider.notifier).clearSuggestHobbies();
      ref.read(SuggestHobbiesViewModel.selectParentHobbyProvider.notifier).update((state) => state = null);
    });
  }

  @override
  void dispose() {
    _hobbyController.dispose();
    _subHobbyController.dispose();
    _suggestionsHobbyController.dispose();
    _suggestionsSubHobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: AppDimens.widgetDimen32pt),
              LabelScreenWidget(
                title: LocaleKeys.suggestHobbies.tr(),
                subtitle: LocaleKeys.subtitleSuggestHobbies.tr(),
                isAxisVirtual: true,
              ),
              SizedBox(height: (context.height - context.appBarH) * 0.1),
              Consumer(
                builder: (context, ref, child) {
                  return SuggestAutoCompleteInputWidget(
                    label: LocaleKeys.hobby.tr(),
                    hintText: LocaleKeys.hintSuggestHobby.tr(),
                    controller: _hobbyController,
                    suggestionsController: _suggestionsHobbyController,
                    suggestionsCallback: (keyword) => _onSuggestionsHobbies(keyword, ref),
                    onSelected: (hobby) => _onSelectedHobbies(hobby, isParentHobby: true),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Consumer(
                builder: (context, ref, child) {
                  final selectParentHobby = ref.watch(SuggestHobbiesViewModel.selectParentHobbyProvider);
                  if (selectParentHobby?.id != null) {
                    return SuggestAutoCompleteInputWidget(
                      label: LocaleKeys.subHobby.tr(),
                      hintText: LocaleKeys.hintSuggestSubHobby.tr(),
                      controller: _subHobbyController,
                      suggestionsController: _suggestionsSubHobbyController,
                      suggestionsCallback: (keyword) => _onSuggestionsSubHobbies(keyword, ref, selectParentHobby!.id!),
                      onSelected: (hobby) => _onSelectedHobbies(hobby, isParentHobby: false),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Consumer(
                builder: (context, ref, child) {
                  return CustomButtonWithLoading(
                    isDisabled: _checkDisableButtonSubmit(ref),
                    title: LocaleKeys.submit.tr(),
                    onPressed: () async => await _onSubmitPressed(ref),
                  );
                },
              ),
              SizedBox(height: context.height * 0.12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmitPressed(WidgetRef ref) async {
    final selectParentHobby = ref.watch(SuggestHobbiesViewModel.selectParentHobbyProvider);

    await ref.read(SuggestHobbiesViewModel.addSuggestHobbiesProvider.notifier).addSuggestHobbies(
          suggestHobbyRequestBody: SuggestHobbyRequestBody(
            suggestedHobby: selectParentHobby?.id == null ? _hobbyController.text : _subHobbyController.text,
            parentId: selectParentHobby?.id,
          ),
        );

    final addSuggestHobbiesState = ref.watch(SuggestHobbiesViewModel.addSuggestHobbiesProvider);
    if (addSuggestHobbiesState.hasValue) {
      navigatorKey.currentContext!.showToast(message: addSuggestHobbiesState.value?.data ?? '');

      Navigator.maybePop(navigatorKey.currentContext!);
    }
    if (addSuggestHobbiesState.hasError) {
      navigatorKey.currentContext!.showToast(message: addSuggestHobbiesState.error.toString());
    }
  }

  void _onSelectedHobbies(HobbyModel hobby, {bool isParentHobby = false}) {
    if (isParentHobby) {
      _hobbyController.text = hobby.name ?? '';
      _suggestionsHobbyController.unfocus();
      ref.read(SuggestHobbiesViewModel.selectParentHobbyProvider.notifier).update((state) => state = hobby);
    } else {
      _subHobbyController.text = hobby.name ?? '';
      _suggestionsSubHobbyController.unfocus();
    }
  }

  bool _checkDisableButtonSubmit(WidgetRef ref) {
    final suggestHobbies = ref.watch(SuggestHobbiesViewModel.getSuggestHobbiesProvider);
    final subHobbySuggestHobbies = ref.watch(SuggestHobbiesViewModel.getSuggestSubHobbiesProvider);
    final selectParentHobby = ref.watch(SuggestHobbiesViewModel.selectParentHobbyProvider);

    return selectParentHobby == null
        ? (_hobbyController.text.isEmpty || (suggestHobbies.hasValue && suggestHobbies.valueOrNull!.isNotEmpty))
        : (_subHobbyController.text.isEmpty ||
            (subHobbySuggestHobbies.hasValue && subHobbySuggestHobbies.valueOrNull!.isNotEmpty));
  }

  FutureOr<List<HobbyModel>?> _onSuggestionsHobbies(String keyword, WidgetRef ref) async {
    bool isSearch = false;
    if (keyword.isEmpty) {
      return [];
    }
    if (keyword != ref.read(SuggestHobbiesViewModel.selectParentHobbyProvider)?.name) {
      ref.read(SuggestHobbiesViewModel.selectParentHobbyProvider.notifier).update((state) => state = null);
      _subHobbyController.clear();
    }
    await Future.delayed(const Duration(seconds: AppConstants.searchDelayTime), () => isSearch = true);
    if (isSearch) {
      await ref
          .read(SuggestHobbiesViewModel.getSuggestHobbiesProvider.notifier)
          .getSuggestHobbiesList(keyword: keyword);
    }

    final suggestHobbies = ref.watch(SuggestHobbiesViewModel.getSuggestHobbiesProvider);
    if (suggestHobbies.hasValue) {
      return suggestHobbies.value;
    }
    return [];
  }

  FutureOr<List<HobbyModel>?> _onSuggestionsSubHobbies(String keyword, WidgetRef ref, int parentHobby) async {
    bool isSearch = false;

    await Future.delayed(const Duration(seconds: AppConstants.searchDelayTime), () => isSearch = true);

    if (isSearch) {
      await ref.read(SuggestHobbiesViewModel.getSuggestSubHobbiesProvider.notifier).getSuggestHobbiesList(
            keyword: keyword,
            parentHobby: parentHobby,
          );
    }
    final suggestHobbiesState = ref.watch(SuggestHobbiesViewModel.getSuggestSubHobbiesProvider);
    if (suggestHobbiesState.hasValue) {
      return suggestHobbiesState.value;
    }
    return [];
  }
}
