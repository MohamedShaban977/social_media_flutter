import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:hauui_flutter/core/constants/enums/image_shape.dart';
import 'package:hauui_flutter/core/constants/enums/post_level.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_vertical.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_level_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class CellEvent extends StatelessWidget {
  final int index;
  final EventModel event;
  final EventType eventType;

  const CellEvent({super.key, required this.event, required this.eventType, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: AppColors.lightGrayishBlue2,
      margin: const EdgeInsets.only(
        bottom: AppDimens.spacingNormal,
        left: AppDimens.spacingNormal,
        right: AppDimens.spacingNormal,
      ),
      elevation: AppDimens.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius12pt),
          side: const BorderSide(
            width: AppDimens.borderWidth0Point5pt,
            color: AppColors.lightGrayishBlue2,
          )),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RoutesNames.eventDetailsRoute,
            arguments: {
              AppConstants.routeEventIdKey: event.id,
              AppConstants.routeEventTypeKey: eventType,
              AppConstants.routeEventIndexKey: index,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        scrollPhysics: const ClampingScrollPhysics(),
                      ),
                      items: event.mediaAttribute!.isNotEmpty
                          ? event.mediaAttribute
                              ?.map((i) => SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: CustomImage.network(
                                      src: i.mediaLink,
                                      imageShape: ImageShape.roundedCorners,
                                    ),
                                  ))
                              .toList()
                          : [
                              CustomImage.svg(
                                src: AppSvg.icPlaceholderHauui,
                                width: context.width,
                                fit: BoxFit.fitWidth,
                              )
                            ],
                    ),
                    const SizedBox(height: AppDimens.widgetDimen24pt),
                  ],
                ),
                PositionedDirectional(
                  end: AppDimens.customSpacing12,
                  bottom: AppDimens.spacingSmall,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final isJoined = ref.watch(EventsViewModel.joinOrLeaveEventsProvider).value;
                      return CustomButtonWithLoading(
                        height: AppDimens.widgetDimen32pt,
                        width: (event.isJoined ?? false) ? AppDimens.widgetDimen80pt : AppDimens.widgetDimen60pt,
                        verticalPadding: AppDimens.customSpacing4,
                        horizontalPadding: AppDimens.customSpacing4,
                        borderColor: AppColors.lightGrayishBlue,
                        backgroundColor: AppColors.white,
                        textColor: (event.isJoined ?? false) ? AppColors.primary : AppColors.veryDarkGrayishBlue,
                        borderRadius: AppDimens.cornerRadius10pt,
                        loaderColor: AppColors.primary,
                        child: (event.isJoined ?? false)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(LocaleKeys.joined.tr()),
                                  const SizedBox(width: AppDimens.widgetDimen4pt),
                                  const CustomImage.svg(
                                    src: AppSvg.icCheckCircle,
                                    width: AppDimens.widgetDimen12pt,
                                  ),
                                ],
                              )
                            : Text(LocaleKeys.join.tr()),
                        onPressed: () async => await _onPressedJoinOrLeaveEvent(ref),
                      );
                    },
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(AppDimens.zero, -AppDimens.spacingSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${event.startDate != null ? event.startDate!.getDateWithDayName() : ''}   -  ${event.endDate != null ? event.endDate!.getDateWithDayName() : ''}',
                      style: TextStyleManager.medium(
                        color: AppColors.grayishBlue,
                        size: AppDimens.textSize12pt,
                      ),
                    ),
                    const SizedBox(height: AppDimens.widgetDimen12pt),
                    Text(
                      event.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleManager.semiBold(),
                    ),
                    const SizedBox(height: AppDimens.widgetDimen8pt),
                    PostLevelWidget.list(
                      level: event.level?.name ?? '-',
                      levelEnum: PostLevelExtensions.tryParse(event.level!.name!.toLowerCase())!,
                    ),
                    const SizedBox(height: AppDimens.widgetDimen12pt),
                    SizedBox(
                      height: AppDimens.widgetDimen32pt,
                      child: Text(
                        event.description ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyleManager.medium(
                          color: AppColors.darkGrayishBlue,
                          size: AppDimens.textSize12pt,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.widgetDimen8pt),
                    if (event.hobbies != null && event.hobbies != [])
                      Wrap(
                        spacing: AppDimens.spacingSmall,
                        children: List.generate(
                          event.hobbies!.length,
                          (index) => Chip(
                            label: Text(
                              event.hobbies?[index].hobby?.name ?? '-',
                              style: TextStyleManager.medium(
                                color: AppColors.darkGrayishBlue,
                                size: AppDimens.textSize12pt,
                              ),
                            ),
                            backgroundColor: AppColors.lightGrayishBlue2,
                            elevation: AppDimens.zero,
                            padding: EdgeInsets.zero,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spacingSmall,
                              vertical: AppDimens.customSpacing4,
                            ),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimens.cornerRadius10pt),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppDimens.widgetDimen12pt),
                    Row(
                      children: [
                        const CustomImage.svg(src: AppSvg.icUser),
                        const SizedBox(width: AppDimens.widgetDimen8pt),
                        Text(
                          LocaleKeys.countGoing.tr(args: [event.joinersCount.toString()]),
                          style: TextStyleManager.medium(
                            color: AppColors.darkGrayishBlue4,
                            size: AppDimens.textSize12pt,
                          ),
                        ),
                        const SizedBox(width: AppDimens.widgetDimen16pt),
                        const SizedBox(
                          height: AppDimens.widgetDimen10pt,
                          child: CustomDividerVertical(
                            color: AppColors.grayishBlue,
                            width: AppDimens.widgetDimen2pt,
                          ),
                        ),
                        const SizedBox(width: AppDimens.widgetDimen16pt),

                        /// event Location
                        CustomImage.svg(
                          src: event.location == EventLocationType.online.name ? AppSvg.icOnline : AppSvg.icLocation,
                        ),

                        const SizedBox(width: AppDimens.widgetDimen8pt),
                        Flexible(
                          child: Text(
                            (event.location == EventLocationType.online.name)
                                ? LocaleKeys.online.tr()
                                : event.addressDetails ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleManager.medium(
                              color: AppColors.darkGrayishBlue4,
                              size: AppDimens.textSize12pt,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.widgetDimen4pt),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedJoinOrLeaveEvent(WidgetRef ref) async {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      if (event.isJoined ?? false) {
        await ref.read(EventsViewModel.joinOrLeaveEventsProvider.notifier).leaveEvent(
              eventId: event.id!,
              userId: UserExtensions.getCachedUser()!.id.toString(),
              eventType: eventType,
              index: index,
            );
      } else {
        await ref.read(EventsViewModel.joinOrLeaveEventsProvider.notifier).joinEvent(
              eventId: event.id!,
              eventType: eventType,
              index: index,
            );
      }
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }
}
