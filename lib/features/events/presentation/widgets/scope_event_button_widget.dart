import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/event_scope.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_outlined_button.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ScopeEventButtonWidget extends StatelessWidget {
  const ScopeEventButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppDimens.spacingNormal,
        end: AppDimens.spacingNormal,
        bottom: AppDimens.spacingSmall,
      ),
      child: SizedBox(
        height: AppDimens.widgetDimen32pt,
        child: Consumer(
          builder: (context, ref, child) {
            final selectedScope = ref.watch(EventsViewModel.selectedScopeProvider);

            return Row(
              children: [
                _ScopeButtonWidget(
                  label: LocaleKeys.going.tr(),
                  isSelectedScope: selectedScope == EventScope.going,
                  onPressed: () => ref.read(EventsViewModel.selectedScopeProvider.notifier).update(
                        (state) => state = EventScope.going,
                      ),
                ),
                const SizedBox(width: AppDimens.widgetDimen12pt),
                _ScopeButtonWidget(
                  label: LocaleKeys.hosting.tr(),
                  isSelectedScope: selectedScope == EventScope.hosted,
                  onPressed: () => ref.read(EventsViewModel.selectedScopeProvider.notifier).update(
                        (state) => state = EventScope.hosted,
                      ),
                ),
                const SizedBox(width: AppDimens.widgetDimen12pt),
                _ScopeButtonWidget(
                  label: LocaleKeys.saved.tr(),
                  isSelectedScope: selectedScope == EventScope.saved,
                  onPressed: () => ref.read(EventsViewModel.selectedScopeProvider.notifier).update(
                        (state) => state = EventScope.saved,
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScopeButtonWidget extends StatelessWidget {
  const _ScopeButtonWidget({
    required this.onPressed,
    required this.label,
    required this.isSelectedScope,
  });

  final void Function()? onPressed;
  final String label;
  final bool isSelectedScope;

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      onPressed: onPressed,
      width: AppDimens.widgetDimen48pt,
      label: label,
      textStyle: TextStyleManager.regular(size: AppDimens.textSize12pt),
      horizontalPadding: AppDimens.zero,
      verticalPadding: AppDimens.zero,
      borderRadius: AppDimens.cornerRadius6pt,
      borderWidth: AppDimens.borderWidth0Point5pt,
      borderColor: isSelectedScope ? AppColors.primary : AppColors.darkGrayishBlue,
      backgroundColor: isSelectedScope ? AppColors.primary : null,
      foregroundColor: isSelectedScope ? AppColors.white : AppColors.veryDarkGrayishBlue,
    );
  }
}
