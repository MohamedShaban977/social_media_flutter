import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_empty_state.dart';
import 'package:hauui_flutter/features/events/data/models/joiners_event_model.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/cell_joiner.dart';
import 'package:hauui_flutter/features/events/presentation/widgets/skeleton_joiners.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'events_view_model.dart';

class JoinersScreen extends ConsumerStatefulWidget {
  final int eventId;

  const JoinersScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<JoinersScreen> createState() => _JoinersScreenState();
}

class _JoinersScreenState extends ConsumerState<JoinersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEvents(eventsPageNumber: ApiConstants.firstPage);
      _handlePagination();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _listener() {
    ref.listen<AsyncValue<JoinersEventModel?>>(
      EventsViewModel.joinersEventsProvider,
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
    final joinersStatus = ref.watch(EventsViewModel.joinersEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.countGoing.tr(
            args: [(joinersStatus.value?.totalCount ?? 0).toString()],
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: joinersStatus.when(
        data: (attendees) => (attendees.joiners ?? []).isEmpty
            ? CustomEmptyState(title: LocaleKeys.noEvent.tr())
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: AppDimens.spacingNormal),
                itemCount: (attendees.joiners ?? []).length + 1,
                itemBuilder: (context, index) => (index == (attendees.joiners ?? []).length)
                    ? ref.read(EventsViewModel.isLastJoinersEventsPageProvider)
                        ? const SizedBox.shrink()
                        : const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingSmall),
                        child: CellJoiner(
                          joiner: (attendees.joiners ?? [])[index],
                          index: index,
                        ),
                      ),
              ),
        error: (error, _) => const SizedBox.shrink(),
        loading: () => const SkeletonJoiners(),
      ),
    );
  }

  Future<void> _getEvents({int? eventsPageNumber}) async {
    await ref
        .read(EventsViewModel.joinersEventsProvider.notifier)
        .getJoinersEvent(eventId: widget.eventId, joinersEventsPageNumber: eventsPageNumber);
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !ref.read(EventsViewModel.isLastJoinersEventsPageProvider)) {
        _getEvents();
      }
    });
  }
}
