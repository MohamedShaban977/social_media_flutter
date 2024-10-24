import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/event_location_type.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_elevated_button.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/add_edit_event_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class EventLocationTypeWidget extends StatelessWidget {
  const EventLocationTypeWidget({super.key, this.validateForm});

  final void Function()? validateForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.eventType.tr(),
          style: TextStyleManager.medium(
            color: AppColors.darkGrayishBlue,
            size: AppDimens.textSize14pt,
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen12pt),
        Consumer(
          builder: (context, ref, child) {
            final selectedTypeEvent = ref.watch(AddEditEventViewModel.selectedEventLocationTypeProvider);
            return Row(
              children: [
                _TypeButton(
                  onPressed: () => {
                    ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider.notifier).state =
                        EventLocationType.online,
                    if (validateForm != null) validateForm!(),
                  },
                  label: LocaleKeys.online.tr(),
                  isSelectedTypeEvent: selectedTypeEvent == EventLocationType.online,
                ),
                const SizedBox(width: AppDimens.widgetDimen12pt),
                _TypeButton(
                  onPressed: () => {
                    ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider.notifier).state =
                        EventLocationType.inPerson,
                    if (validateForm != null) validateForm!(),
                  },
                  label: LocaleKeys.inPerson.tr(),
                  isSelectedTypeEvent: selectedTypeEvent == EventLocationType.inPerson,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.onPressed,
    required this.label,
    required this.isSelectedTypeEvent,
  });

  final void Function()? onPressed;
  final String label;
  final bool isSelectedTypeEvent;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: onPressed,
      width: AppDimens.widgetDimen100pt,
      label: label,
      textStyle: TextStyleManager.semiBold(
        color: AppColors.darkGrayishBlue,
        size: AppDimens.textSize12pt,
      ),
      horizontalPadding: AppDimens.spacingSmall,
      verticalPadding: AppDimens.spacingSmall,
      borderRadius: AppDimens.cornerRadius8pt,
      borderWidth: AppDimens.borderWidth0Point5pt,
      style: ElevatedButton.styleFrom(
        elevation: AppDimens.zero,
      ),
      backgroundColor: isSelectedTypeEvent ? AppColors.primary : AppColors.lightGrayishBlue4,
      foregroundColor: isSelectedTypeEvent ? AppColors.white : AppColors.veryDarkGrayishBlue,
    );
  }
}
