import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';

import 'cell_event.dart';
import 'skeleton_cell_event.dart';

class ListYouMayLikeEvent extends ConsumerStatefulWidget {
  final int eventId;

  const ListYouMayLikeEvent({super.key, required this.eventId});

  @override
  ConsumerState<ListYouMayLikeEvent> createState() => _YouMayLikeEventListWidgetState();
}

class _YouMayLikeEventListWidgetState extends ConsumerState<ListYouMayLikeEvent> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getYouMayLikeEvent(eventsPageNumber: ApiConstants.firstPage);
      _handlePagination();
    });
  }

  Future<void> _getYouMayLikeEvent({int? eventsPageNumber}) async {
    await ref.read(EventsViewModel.youMayLikeEventsProvider.notifier).getYouMayLikeEvent(
          eventId: widget.eventId,
          youMayLikeEventsPageNumber: eventsPageNumber,
        );
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !ref.read(EventsViewModel.isLastYouMayLikeEventsPageProvider)) {
        _getYouMayLikeEvent();
      }
    });
  }

  void _listener() {
    ref.listen<AsyncValue<List<EventModel>>>(
      EventsViewModel.youMayLikeEventsProvider,
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
    final youMayLikeEvents = ref.watch(EventsViewModel.youMayLikeEventsProvider);

    return youMayLikeEvents.when(
      data: (events) => ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: events.length + 1,
        itemBuilder: (context, index) => (index == events.length)
            ? ref.watch(EventsViewModel.isLastYouMayLikeEventsPageProvider)
                ? const SizedBox.shrink()
                : const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: context.width,
                child: CellEvent(
                  event: events[index],
                  eventType: EventType.youMayLike,
                  index: index,
                ),
              ),
      ),
      error: (error, _) => const SizedBox.shrink(),
      loading: () => const SkeletonCellEvent(),
    );
  }
}
