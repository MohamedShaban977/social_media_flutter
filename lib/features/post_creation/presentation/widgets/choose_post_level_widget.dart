import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/post_level.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/invalid_input_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_level_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ChoosePostLevelWidget extends StatelessWidget {
  final ValueNotifier<bool?> isLevelSelected;

  const ChoosePostLevelWidget({
    super.key,
    required this.isLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            bottom: AppDimens.customSpacing12,
          ),
          child: Text(
            LocaleKeys.choosePostLevel.tr(),
            style: TextStyleManager.medium(
              size: AppDimens.textSize14pt,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: PostLevel.values
                .map(
                  (postLevel) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppDimens.spacingSmall),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final selectedLevel = ref.watch(
                          PostCreationViewModel.selectedLevelIdProvider,
                        );
                        return InkWell(
                          onTap: () => _onLevelTapped(
                            ref: ref,
                            postLevel: postLevel,
                          ),
                          child: PostLevelWidget.create(
                            level: postLevel.toStr(),
                            levelEnum: postLevel,
                            isSelected: selectedLevel == postLevel.id,
                          ),
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        ValueListenableBuilder(
          builder: (context, isLevelSelected, child) => isLevelSelected == null || isLevelSelected == true
              ? const SizedBox.shrink()
              : InvalidInputWidget(
                  errorMessage: LocaleKeys.itsRequiredToChoosePostLevel.tr(),
                ),
          valueListenable: isLevelSelected,
        ),
      ],
    );
  }

  void _onLevelTapped({
    required WidgetRef ref,
    required PostLevel postLevel,
  }) {
    ref.read(PostCreationViewModel.selectedLevelIdProvider.notifier).update(
          (state) => state = postLevel.id,
        );
  }
}
