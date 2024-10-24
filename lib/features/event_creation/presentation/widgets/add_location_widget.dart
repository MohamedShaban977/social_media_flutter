import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/add_edit_event_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AddLocationWidget extends ConsumerWidget {
  const AddLocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingNormal),
      child: Column(
        children: [
          Row(
            children: [
              const CustomImage.svg(src: AppSvg.icLocationOutline),
              const SizedBox(width: AppDimens.widgetDimen12pt),
              Text(
                LocaleKeys.addLocation.tr(),
                style: TextStyleManager.medium(
                  size: AppDimens.textSize14pt,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(RoutesNames.addLocationRoute),
                child: const CustomImage.svg(
                  src: AppSvg.icAddSquared,
                  width: AppDimens.widgetDimen24pt,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              if (ref.watch(AddEditEventViewModel.addressDetailProvider) != null) {
                return Column(
                  children: [
                    const SizedBox(height: AppDimens.widgetDimen12pt),
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.grayishBlue),
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius6pt),
                        ),
                      ),
                      padding: const EdgeInsetsDirectional.only(
                          top: AppDimens.customSpacing12,
                          bottom: AppDimens.zero,
                          start: AppDimens.customSpacing12,
                          end: AppDimens.customSpacing12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.read(AddEditEventViewModel.addressDetailProvider) ?? '',
                            style: TextStyleManager.regular(
                              size: AppDimens.textSize14pt,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => Navigator.of(context).pushNamed(RoutesNames.addLocationRoute),
                                icon: const CustomImage.svg(
                                  src: AppSvg.icEditOutline,
                                  width: AppDimens.widgetDimen16pt,
                                  height: AppDimens.widgetDimen16pt,
                                ),
                                label: Text(
                                  LocaleKeys.edit.tr(),
                                  style: TextStyleManager.regular(
                                    size: AppDimens.textSize12pt,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => {
                                  ref.invalidate(AddEditEventViewModel.addressProvider),
                                  ref.invalidate(AddEditEventViewModel.addressDetailProvider),
                                  ref.invalidate(AddEditEventViewModel.latitudeProvider),
                                  ref.invalidate(AddEditEventViewModel.longitudeProvider),
                                },
                                icon: const CustomImage.svg(
                                  src: AppSvg.icDelete,
                                  width: AppDimens.widgetDimen16pt,
                                  height: AppDimens.widgetDimen16pt,
                                ),
                                label: Text(
                                  LocaleKeys.delete.tr(),
                                  style: TextStyleManager.regular(
                                    size: AppDimens.textSize12pt,
                                    color: AppColors.red,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: AppColors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
