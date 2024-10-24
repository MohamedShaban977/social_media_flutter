import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/about_event_widget.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/sliver_app_bar_event_widget.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/sliver_persistent_header_event.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'events_view_model.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  final int eventId;
  final EventType eventType;
  final int index;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.eventType,
    required this.index,
  });

  @override
  ConsumerState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final TabController _tabController;
  final _silverCollapsed = ValueNotifier<bool>(false);
  final _indexTabBar = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
      animationDuration: Duration.zero,
    );

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _indexTabBar.value = 0;
      } else {
        _indexTabBar.value = 1;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _listenScrollController();
      ref.invalidate(EventsViewModel.eventDetailsProvider);
      await ref.read(EventsViewModel.eventDetailsProvider.notifier).getEventDetails(eventId: widget.eventId);
      ref.read(EventsViewModel.indexEventProvider.notifier).state = widget.index;
      ref
          .read(EventsViewModel.joinOrLeaveEventsProvider.notifier)
          .set(ref.read(EventsViewModel.eventDetailsProvider).value?.isJoined ?? false);
    });
  }

  void _listenScrollController() {
    final double heightAppBarSilver =
        ((context.isSmallDevice ? context.height * 0.85 : context.height * 0.75) - kToolbarHeight);

    _scrollController.addListener(() {
      if (_scrollController.offset > heightAppBarSilver && !_scrollController.position.outOfRange) {
        if (!_silverCollapsed.value) {
          _silverCollapsed.value = true;
        }
      }
      if (_scrollController.offset <= heightAppBarSilver && !_scrollController.position.outOfRange) {
        if (_silverCollapsed.value) {
          _silverCollapsed.value = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _listener() {
    ref.listen<AsyncValue<EventModel?>>(
      EventsViewModel.eventDetailsProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final eventDetailsStatus = ref.watch(EventsViewModel.eventDetailsProvider);
    return Scaffold(
      body: eventDetailsStatus.when(
        error: (error, _) => const SizedBox.shrink(),
        loading: () => const CustomProgressIndicator(),
        data: (eventDetails) => CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            MultiSliver(
              children: [
                /// SliverAppBarEvent
                ValueListenableBuilder(
                    valueListenable: _silverCollapsed,
                    builder: (context, silverCollapsed, child) {
                      return SliverAppBarEventWidget(
                        silverCollapsed: silverCollapsed,
                        eventModel: eventDetails!,
                        eventType: widget.eventType,
                        index: widget.index,
                      );
                    }),

                /// Sliver Persistent Header Event
                SliverPersistentHeaderEvent(tabController: _tabController),

                // about and discussion
                ValueListenableBuilder(
                  valueListenable: _indexTabBar,
                  builder: (context, value, child) => (value == 0)
                      ? SizedBox(
                          height: context.heightBody - AppDimens.widgetDimen59pt,
                          child: AboutEventWidget(
                            eventDetails: eventDetails,
                          ),
                        )

                      ///TODO: add discussion Widget
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spacingNormal, vertical: AppDimens.spacingNormal),
                          child: Container(
                            height: AppDimens.widgetDimen59pt,
                            color: Colors.amber,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
