import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class SliverPersistentHeaderEvent extends StatelessWidget {
  const SliverPersistentHeaderEvent({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        minHeight: AppDimens.widgetDimen59pt,
        maxHeight: AppDimens.widgetDimen59pt,
        child: Container(
          padding: const EdgeInsets.only(top: AppDimens.spacingNormal),
          color: AppColors.white,
          child: CustomTabbedWidget(
            currentTabIndex: 0,
            tabController: _tabController,
            tabsLabels: [
              LocaleKeys.about.tr(),
              LocaleKeys.discussion.tr(),
            ],
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              2,
              (index) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
