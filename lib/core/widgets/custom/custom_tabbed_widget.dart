import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/iterable_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/tab_indicator_default.dart';

class CustomTabbedWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabsLabels;
  final int currentTabIndex;
  final double? height;

  final List<Widget> children;
  final ScrollPhysics? physics;
  final double spaceTapBarHeight;
  final double dividerHeight;

  const CustomTabbedWidget({
    super.key,
    required this.tabController,
    required this.tabsLabels,
    required this.currentTabIndex,
    this.children = const <Widget>[],
    this.physics = const ClampingScrollPhysics(),
    this.spaceTapBarHeight = AppDimens.widgetDimen16pt,
    this.height,
    this.dividerHeight = AppDimens.dividerThickness1pt,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: height ?? (context.height - context.topPadding - context.bottomPadding),
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            isScrollable: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.only(start: AppDimens.spacingNormal),
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsetsDirectional.only(
              end: AppDimens.spacingLarge,
              bottom: AppDimens.spacingSmall,
            ),
            labelColor: AppColors.veryDarkGrayishBlue,
            unselectedLabelColor: AppColors.grayishBlue,
            labelStyle: TextStyleManager.semiBold(
              size: AppDimens.textSize14pt,
            ),
            unselectedLabelStyle: TextStyleManager.medium(
              size: AppDimens.textSize14pt,
            ),
            indicatorColor: AppColors.vividCyan,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: const EdgeInsetsDirectional.only(start: AppDimens.spacingSmall),
            indicator: const TabIndicatorDefault(
              color: AppColors.vividCyan,
              indicatorHeight: AppDimens.strokeWidth3pt,
            ),
            dividerColor: AppColors.grayishBlue,
            dividerHeight: dividerHeight,
            tabs: tabsLabels
                .mapIndexed(
                  (tabLabel, index) => Text(tabLabel),
                )
                .toList(),
          ),
          SizedBox(height: spaceTapBarHeight),
          Expanded(
            child: TabBarView(
              physics: physics,
              controller: tabController,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
