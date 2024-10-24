import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';

import 'info_event_widget.dart';
import 'slider_images_widget.dart';

class SliverAppBarEventWidget extends StatelessWidget {
  const SliverAppBarEventWidget({
    super.key,
    required this.silverCollapsed,
    required this.eventModel,
    required this.eventType,
    required this.index,
  });

  final bool silverCollapsed;
  final EventModel eventModel;
  final EventType eventType;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: false,
      pinned: true,
      floating: false,
      expandedHeight: context.isSmallDevice ? context.height * 0.95 : context.height * 0.85,
      title: silverCollapsed ? Text(eventModel.title ?? '-') : null,
      centerTitle: true,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      bottom: silverCollapsed
          ? const PreferredSize(
              preferredSize: Size(AppDimens.zero, AppDimens.widgetDimen4pt),
              child: CustomDividerHorizontal(),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SliderImagesWidget(
              images: eventModel.mediaAttribute != null && eventModel.mediaAttribute!.isNotEmpty
                  ? eventModel.mediaAttribute!.map((e) => e.mediaLink!).toList()
                  : [],
            ),
            const SizedBox(height: AppDimens.widgetDimen16pt),
            InfoEventWidget(
              eventDetails: eventModel,
              eventType: eventType,
              index: index,
            ),
          ],
        ),
      ),
      leading: InkWell(
        onTap: () => Navigator.maybePop(context),
        child: silverCollapsed
            ? const Icon(
                Icons.arrow_back_ios,
              )
            : Container(
                margin: const EdgeInsets.all(AppDimens.spacingSmall),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.darkGrayishBlue2.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius10pt)),
                child: Transform.translate(
                  offset: const Offset(AppDimens.customSpacing4, AppDimens.zero),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
