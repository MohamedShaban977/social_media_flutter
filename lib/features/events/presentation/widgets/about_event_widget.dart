import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'list_you_may_like_event.dart';

class AboutEventWidget extends StatelessWidget {
  final EventModel? eventDetails;

  const AboutEventWidget({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eventDetails?.hashtags != null)
                Wrap(
                  spacing: AppDimens.spacingSmall,
                  children: List.generate(
                    eventDetails!.hashtags!.length,
                    (index) => Text(
                      LocaleKeys.hashtag.tr(args: [eventDetails?.hashtags?[index].name ?? '-']),
                      textAlign: TextAlign.start,
                      style: TextStyleManager.bold(
                        size: AppDimens.textSize14pt,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppDimens.widgetDimen4pt),
              Text(
                eventDetails?.description ?? '-',
                textAlign: TextAlign.start,
                style: TextStyleManager.regular(
                  size: AppDimens.textSize14pt,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Text(
                LocaleKeys.yourMayLike.tr(),
                style: TextStyleManager.semiBold(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen16pt),
        SizedBox(
          height: AppDimens.widgetDimen445pt,
          width: context.width,
          child: ListYouMayLikeEvent(
            eventId: eventDetails!.id!,
          ),
        ),
      ],
    );
  }
}
