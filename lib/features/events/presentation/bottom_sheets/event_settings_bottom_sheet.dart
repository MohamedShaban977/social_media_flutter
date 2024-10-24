import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/main_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/list_settings.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/setting_widget.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/setting_event_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import 'report_event_bottom_sheet.dart';

class EventSettingsBottomSheet extends ConsumerWidget {
  const EventSettingsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventDetails = ref.watch(EventsViewModel.eventDetailsProvider).value;

    return MainBottomSheet(
      title: LocaleKeys.setting.tr(),
      child: ListSettings(
        buttons: <SettingWidget>[
          (eventDetails?.isOwner ?? false)
              ? SettingWidget(
                  label: LocaleKeys.edit.tr(),
                  onPressed: () => _onEditEventPressed(ref, eventDetails),
                )
              : SettingWidget(
                  label: (eventDetails?.isSaved ?? false) ? LocaleKeys.unsave.tr() : LocaleKeys.save.tr(),
                  onPressed: () => _onSaveUnSaveEventPressed(ref, eventDetails),
                ),
          SettingWidget(
            label: LocaleKeys.share.tr(),
            onPressed: () => _onShareEventPressed(ref, eventDetails),
          ),
          if (!(eventDetails?.isOwner ?? false))
            SettingWidget(
              label: LocaleKeys.hide.tr(),
              onPressed: () => _onHideEventPressed(ref, eventDetails),
            ),
          (eventDetails?.isOwner ?? false)
              ? SettingWidget(
                  label: LocaleKeys.delete.tr(),
                  onPressed: () => _onDeleteEventPressed(ref, eventDetails),
                )
              : SettingWidget(
                  label: LocaleKeys.report.tr(),
                  onPressed: () => _onReportEventPressed(ref, context, eventDetails),
                ),
        ],
      ),
    );
  }

  void _onEditEventPressed(WidgetRef ref, EventModel? eventDetails) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        RoutesNames.editEventRoute,
        arguments: {AppConstants.routeEventIdKey: eventDetails!.id!},
      );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  void _onSaveUnSaveEventPressed(WidgetRef ref, EventModel? eventDetails) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      SettingEventViewModel.saveUnsaveEvent(
        eventId: eventDetails!.id!,
        onSuccess: (successMassage) => {
          navigatorKey.currentContext!.showToast(message: successMassage),
          eventDetails.isSaved = !(eventDetails.isSaved ?? false),
          Navigator.pop(navigatorKey.currentContext!),
        },
        onFail: (errorMassage) => {
          navigatorKey.currentContext!.showToast(message: errorMassage),
          Navigator.pop(navigatorKey.currentContext!),
        },
      );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  Future<void> _onShareEventPressed(WidgetRef ref, EventModel? eventDetails) async {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      return Share.shareUri(Uri.parse(eventDetails?.dynamicLink ?? '')).then(
        (value) => Navigator.of(navigatorKey.currentContext!).pop(),
      );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  void _onHideEventPressed(WidgetRef ref, EventModel? eventDetails) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      _showDialogConfirmHiddenEvent(eventDetails, ref).whenComplete(
        () => Navigator.pop(navigatorKey.currentContext!),
      );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  void _onDeleteEventPressed(WidgetRef ref, EventModel? eventDetails) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      _showDialogConfirmDeleteEvent(eventDetails, ref).whenComplete(
        () => Navigator.pop(navigatorKey.currentContext!),
      );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  void _onReportEventPressed(WidgetRef ref, BuildContext context, EventModel? eventDetails) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized) {
      context
          .showBottomSheet(
            widget: MainBottomSheet(
              title: LocaleKeys.reportReason.tr(),
              child: ReportEventBottomSheet(
                eventId: eventDetails!.id!,
              ),
            ),
          )
          .whenComplete(
            () => Navigator.pop(context),
          );
    } else {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    }
  }

  Future<void> _showDialogConfirmDeleteEvent(EventModel? eventDetails, WidgetRef ref) async {
    return await navigatorKey.currentContext!.showAdaptiveDialog(
      content: LocaleKeys.massageConfirmDeleteEvent.tr(),
      positiveBtnName: LocaleKeys.yes.tr(),
      positiveBtnAction: () => SettingEventViewModel.deleteEvent(
        eventId: eventDetails!.id!,
        onSuccess: (successMassage) async {
          await ref
              .read(EventsViewModel.eventsProvider.notifier)
              .deleteEvent(index: ref.read(EventsViewModel.indexEventProvider));
          navigatorKey.currentContext!.showToast(message: successMassage);
          Navigator.pop(navigatorKey.currentContext!);
        },
        onFail: (errorMassage) => {
          navigatorKey.currentContext!.showToast(message: errorMassage),
        },
      ),
      negativeBtnName: LocaleKeys.no.tr(),
      cancelable: true,
    );
  }

  Future<void> _showDialogConfirmHiddenEvent(EventModel? eventDetails, WidgetRef ref) async {
    return await navigatorKey.currentContext!.showAdaptiveDialog(
      content: LocaleKeys.massageConfirmHiddenEvent.tr(),
      positiveBtnName: LocaleKeys.yes.tr(),
      positiveBtnAction: () => SettingEventViewModel.hiddenEvents(
        eventId: eventDetails!.id!,
        onSuccess: (successMassage) async {
          await ref
              .read(EventsViewModel.eventsProvider.notifier)
              .deleteEvent(index: ref.read(EventsViewModel.indexEventProvider));
          navigatorKey.currentContext!.showToast(message: successMassage);
          Navigator.pop(navigatorKey.currentContext!);
        },
        onFail: (errorMassage) => {
          navigatorKey.currentContext!.showToast(message: errorMassage),
        },
      ),
      negativeBtnName: LocaleKeys.no.tr(),
      cancelable: true,
    );
  }
}
