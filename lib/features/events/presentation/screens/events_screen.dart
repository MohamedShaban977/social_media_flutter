import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';
import 'package:hauui_flutter/features/events/presentation/bottom_sheets/choose_locations_widget.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/list_events.dart';
import 'package:hauui_flutter/features/main_layout/presentation/widgets/tool_bar_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final ValueNotifier<bool> _isVisibleEditLocation = ValueNotifier<bool>(false);
  final _locationUtil = const LocationUtil();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: AppConstants.animationDurationMilliseconds),
    )..addListener(() {
        _isVisibleEditLocation.value = _tabController.index == 2;
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isVisibleEditLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ToolBarWidget(
            title: LocaleKeys.events.tr(),
          ),
          Expanded(
            child: Stack(
              children: [
                CustomTabbedWidget(
                  tabController: _tabController,
                  tabsLabels: [
                    LocaleKeys.forYou.tr(),
                    LocaleKeys.yourEvent.tr(),
                    LocaleKeys.discover.tr(),
                  ],
                  currentTabIndex: 0,
                  dividerHeight: AppDimens.dividerThickness0Point1pt,
                  children: const [
                    ListEvents.forYou(),
                    ListEvents.yourEvent(),
                    ListEvents.discover(),
                  ],
                ),
                PositionedDirectional(
                  end: 0,
                  top: 0,
                  child: ValueListenableBuilder(
                    valueListenable: _isVisibleEditLocation,
                    builder: (context, isVisible, child) => Visibility(
                      visible: isVisible,
                      replacement: const SizedBox.shrink(),
                      child: InkWell(
                        onTap: () async => await showChooseLocationBottomSheet(ref),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.spacingNormal),
                          child: CustomImage.svg(src: AppSvg.icLocationEvent),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showChooseLocationBottomSheet(WidgetRef ref) async {
    final latitude = ref.read(EventsViewModel.latitudeProvider);
    final longitude = ref.read(EventsViewModel.longitudeProvider);
    Placemark? place;
    if (latitude != null && longitude != null) {
      place = await _locationUtil.getAddressFromLatLng(latitude, longitude);
    }
    navigatorKey.currentContext!.showBottomSheet(
        widget: ChooseLocationsWidget(address: "${place?.administrativeArea ?? '-'}, ${place?.country ?? '-'}"));
  }
}
