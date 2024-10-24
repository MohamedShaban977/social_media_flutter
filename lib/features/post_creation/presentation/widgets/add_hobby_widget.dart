import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/invalid_input_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/hobbies_screen.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/chip_solid_light_grayish_blue2_opacity40_corner14.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AddHobbyWidget extends StatelessWidget {
  final ValueNotifier<bool?> isHobbySelected;

  const AddHobbyWidget({
    super.key,
    required this.isHobbySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CustomImage.svg(
              src: AppSvg.icLogoHauuiRounded,
            ),
            const SizedBox(
              width: AppDimens.widgetDimen12pt,
            ),
            Text(
              LocaleKeys.addHobbyMustAdded.tr(),
              style: TextStyleManager.medium(
                size: AppDimens.textSize14pt,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => _onEditTapped(
                context: context,
              ),
              child: const CustomImage.svg(
                src: AppSvg.icEdit,
              ),
            ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            final selectedHobbies = ref.watch(
              PostCreationViewModel.selectedHobbiesProvider,
            );
            return Visibility(
              visible: selectedHobbies.isNotEmpty,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppDimens.spacingXLarge,
                  top: AppDimens.customSpacing12,
                ),
                child: Row(
                  children: selectedHobbies
                      .map(
                        (selectedHobby) => ChipSolidLightGrayishBlue2Opacity40Corner14(
                          title: '${selectedHobby.name}',
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          builder: (context, isHobbySelected, child) => isHobbySelected == null || isHobbySelected == true
              ? const SizedBox.shrink()
              : InvalidInputWidget(
                  errorMessage: LocaleKeys.itsRequiredToSelectAtLeastOneHobby.tr(),
                ),
          valueListenable: isHobbySelected,
        ),
      ],
    );
  }

  void _onEditTapped({
    required BuildContext context,
  }) {
    context.showBottomSheet(
      widget: SizedBox(
        height: context.height * 0.95,
        child: const HobbiesScreen.postCreation(),
      ),
    );
  }
}
