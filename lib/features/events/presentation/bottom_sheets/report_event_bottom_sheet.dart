import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/setting_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/events/presentation/screens/setting_event_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ReportEventBottomSheet extends ConsumerStatefulWidget {
  final int eventId;

  const ReportEventBottomSheet({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState createState() => _ReportEventBottomSheetState();
}

class _ReportEventBottomSheetState extends ConsumerState<ReportEventBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(SettingEventViewModel.reportReasonEventProvider.notifier).getReportReasonEvent();
    });
  }

  void _listen() {
    ref.listen<AsyncValue<List<IntKeyStingValueModel>?>>(
      SettingEventViewModel.reportReasonEventProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => {
          context.showToast(message: error.toString()),
          Navigator.pop(context),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    final reportReasonEventState = ref.watch(SettingEventViewModel.reportReasonEventProvider);
    return reportReasonEventState.when(
      data: (reportReason) => reportReason != []
          ? Container(
              constraints: BoxConstraints(
                maxHeight: context.height * 0.3,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
                  child: ListView.builder(
                    itemCount: reportReason!.length,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingWidget(
                          label: reportReason[index].name ?? '',
                          onPressed: () {
                            SettingEventViewModel.reportedEvents(
                              eventId: widget.eventId,
                              reportReasonId: reportReason[index].id!,
                              onSuccess: (successMassage) => {
                                context.showToast(message: successMassage),
                                Navigator.pop(context),
                              },
                              onFail: (errorMassage) => {
                                context.showToast(message: errorMassage),
                                Navigator.pop(context),
                              },
                            );
                          },
                        ),
                        (index == reportReason.length - 1)
                            ? const SizedBox(height: AppDimens.widgetDimen16pt)
                            : const CustomDividerHorizontal(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              height: AppDimens.widgetDimen100pt,
              child: Center(
                child: Text(
                  LocaleKeys.notFound.tr(),
                ),
              ),
            ),
      error: (error, _) => const SizedBox.shrink(),
      loading: () => const SizedBox(height: AppDimens.widgetDimen100pt, child: CustomProgressIndicator()),
    );
  }
}
