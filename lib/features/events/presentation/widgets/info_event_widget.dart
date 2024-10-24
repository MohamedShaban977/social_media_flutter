import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/event_location_type.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/constants/enums/post_level.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/hobbies_chips_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_outlined_button.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/bottom_sheets/event_settings_bottom_sheet.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_level_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class InfoEventWidget extends StatelessWidget {
  const InfoEventWidget({
    super.key,
    required this.eventDetails,
    required this.eventType,
    required this.index,
  });

  final EventModel? eventDetails;
  final EventType eventType;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title
          Text(
            eventDetails?.title ?? '-',
            style: TextStyleManager.semiBold(
              size: AppDimens.textSize18pt,
            ),
          ),
          const SizedBox(height: AppDimens.widgetDimen8pt),

          /// Level
          PostLevelWidget.list(
            level: eventDetails?.level?.name ?? '-',
            levelEnum: PostLevelExtensions.tryParse(eventDetails!.level!.name!.toLowerCase())!,
          ),
          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// Start Date and End Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(AppDimens.zero, AppDimens.widgetDimen2pt),
                child: const CustomImage.svg(src: AppSvg.icClock),
              ),
              const SizedBox(width: AppDimens.widgetDimen12pt),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventDetails?.startDate != null
                        ? eventDetails!.startDate!.getFormattedDateTime(
                            context.locale.languageCode,
                            AppConstants.patternMMMDDYYYYHHMMA,
                          )
                        : '-',
                    style: TextStyleManager.medium(
                      color: AppColors.darkGrayishBlue,
                      size: AppDimens.textSize14pt,
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen4pt),
                  Text(
                    eventDetails?.endDate != null
                        ? eventDetails!.endDate!.getFormattedDateTime(
                            context.locale.languageCode,
                            AppConstants.patternMMMDDYYYYHHMMA,
                          )
                        : '-',
                    style: TextStyleManager.medium(
                      color: AppColors.darkGrayishBlue,
                      size: AppDimens.textSize14pt,
                    ),
                  ),
                ],
              )
            ],
          ),
          InkWell(
            onTap: eventDetails?.latestJoiners != null && eventDetails!.latestJoiners!.isNotEmpty
                ? () {
                    Navigator.pushNamed(
                      context,
                      RoutesNames.joinersRoute,
                      arguments: {AppConstants.routeEventIdKey: eventDetails?.id},
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingNormal),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomImage.svg(src: AppSvg.icGroupUsers),
                  const SizedBox(width: AppDimens.widgetDimen12pt),
                  Text(
                    LocaleKeys.countGoing.tr(args: [eventDetails?.joinersCount.toString() ?? '0']),
                    style: TextStyleManager.medium(
                      color: AppColors.darkGrayishBlue,
                      size: AppDimens.textSize14pt,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomImage.svg(src: AppSvg.icUser),
              const SizedBox(width: AppDimens.widgetDimen12pt),
              Expanded(
                child: Text.rich(
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.eventBy.tr(),
                        style: TextStyleManager.medium(
                          color: AppColors.darkGrayishBlue,
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: AppDimens.widgetDimen8pt)),
                      TextSpan(
                        text: eventDetails?.owner?.name ?? '-',
                        style: TextStyleManager.semiBold(
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(AppDimens.zero, AppDimens.widgetDimen4pt),
                child: CustomImage.svg(
                  src: eventDetails?.location == EventLocationType.online.name ? AppSvg.icOnline : AppSvg.icLocation,
                ),
              ),
              const SizedBox(width: AppDimens.widgetDimen12pt),
              if (eventDetails?.location == EventLocationType.online.name)
                Text(
                  LocaleKeys.online.tr(),
                  style: TextStyleManager.medium(
                    color: AppColors.darkGrayishBlue,
                    size: AppDimens.textSize14pt,
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventDetails?.address ?? '-',
                        style: TextStyleManager.medium(
                          color: AppColors.darkGrayishBlue,
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                      const SizedBox(height: AppDimens.widgetDimen4pt),
                      Text(
                        eventDetails?.addressDetails ?? '-',
                        style: TextStyleManager.medium(
                          color: AppColors.darkGrayishBlue,
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// link
          if (eventDetails?.website != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomImage.svg(src: AppSvg.icFilledLink),
                const SizedBox(width: AppDimens.widgetDimen12pt),
                Text(
                  eventDetails?.website ?? '',
                  style: TextStyleManager.medium(
                    color: AppColors.darkGrayishBlue,
                    size: AppDimens.textSize14pt,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// hobbies
          HobbiesChipsWidget(
            hobbies: eventDetails?.hobbies?.map((e) => e.hobby!.name!).toList() ?? [],
          ),
          const SizedBox(height: AppDimens.widgetDimen8pt),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.7,
                height: AppDimens.widgetDimen45pt,
                child: Center(
                  child: _JoinOrLeaveButton(
                    event: eventDetails!,
                    eventType: eventType,
                    index: index,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.widgetDimen12pt),
              CustomOutlinedButton(
                onPressed: () => _showSettingBottomSheet(),
                width: AppDimens.widgetDimen55pt,
                height: AppDimens.widgetDimen45pt,
                verticalPadding: AppDimens.zero,
                child: const Icon(Icons.more_horiz_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showSettingBottomSheet() {
    navigatorKey.currentContext!.showBottomSheet(
      widget: const EventSettingsBottomSheet(),
    );
  }
}

class _JoinOrLeaveButton extends ConsumerWidget {
  final EventModel event;
  final EventType eventType;
  final int index;

  const _JoinOrLeaveButton({
    required this.event,
    required this.eventType,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJoined = ref.watch(EventsViewModel.joinOrLeaveEventsProvider).value;
    return CustomButtonWithLoading(
      width: context.width * 0.7,
      height: AppDimens.widgetDimen45pt,
      verticalPadding: AppDimens.zero,
      horizontalPadding: AppDimens.zero,
      borderColor: AppColors.primary,
      backgroundColor: (isJoined ?? false) || (event.isJoined ?? false) ? AppColors.white : AppColors.primary,
      textColor: (isJoined ?? false) || (event.isJoined ?? false) ? AppColors.primary : AppColors.white,
      borderRadius: AppDimens.cornerRadius4pt,
      loaderColor: (isJoined ?? false) || (event.isJoined ?? false) ? AppColors.primary : AppColors.white,
      child: (isJoined ?? false) || (event.isJoined ?? false)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.joined.tr()),
                const SizedBox(width: AppDimens.customSpacing4),
                const CustomImage.svg(
                  src: AppSvg.icCheckCircle,
                  width: AppDimens.widgetDimen12pt,
                ),
              ],
            )
          : Text(
              LocaleKeys.join.tr(),
            ),
      onPressed: () async => await _onPressedJoinOrLeaveEvent(ref),
    );
  }

  Future<void> _onPressedJoinOrLeaveEvent(WidgetRef ref) async {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      if (event.isJoined ?? false) {
        await ref.read(EventsViewModel.joinOrLeaveEventsProvider.notifier).leaveEvent(
              eventId: event.id!,
              userId: UserExtensions.getCachedUser()!.id.toString(),
              eventType: eventType,
              isDetailsEvent: true,
              index: index,
            );
      } else {
        await ref.read(EventsViewModel.joinOrLeaveEventsProvider.notifier).joinEvent(
              eventId: event.id!,
              eventType: eventType,
              isDetailsEvent: true,
              index: index,
            );
      }
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }
}
