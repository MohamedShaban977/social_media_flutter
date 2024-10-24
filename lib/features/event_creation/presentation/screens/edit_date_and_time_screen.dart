import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/dropdown_button_form_field2_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_button.dart';
import 'package:hauui_flutter/features/event_creation/data/models/timezone_model.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/edit_date_and_time_view_model.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/app_bar_date_and_time_event.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class EditDateAndTimeScreen extends ConsumerStatefulWidget {
  const EditDateAndTimeScreen({super.key});

  @override
  ConsumerState<EditDateAndTimeScreen> createState() => _EditDateAndTimeState();
}

class _EditDateAndTimeState extends ConsumerState<EditDateAndTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  TimezoneModel? _selectTimezone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(EditDateAndTimeViewModel.timezonesProvider.notifier).getLookupTimezone();
      _initializeDateTime();
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _initializeDateTime() {
    if (ref.read(EditDateAndTimeViewModel.startDateProvider) != null) {
      _startDateController.text = ref
          .read(EditDateAndTimeViewModel.startDateProvider)!
          .getFormattedDateTime(context.locale.languageCode, AppConstants.patternMMMDDYYYY);
      _startDate = ref.read(EditDateAndTimeViewModel.startDateProvider);
    } else {
      _startDateController.text =
          DateTime.now().getFormattedDateTime(context.locale.languageCode, AppConstants.patternMMMDDYYYY);
      _startDate = DateTime.now();
    }

    if (ref.read(EditDateAndTimeViewModel.startTimeProvider) != null) {
      _startTimeController.text = ref.read(EditDateAndTimeViewModel.startTimeProvider)!.format(context);
      _startTime = ref.read(EditDateAndTimeViewModel.startTimeProvider);
    } else {
      _startTimeController.text = TimeOfDay.now().format(context);
      _startTime = TimeOfDay.now();
    }

    if (ref.read(EditDateAndTimeViewModel.endDateProvider) != null) {
      _endDateController.text = ref
          .read(EditDateAndTimeViewModel.endDateProvider)!
          .getFormattedDateTime(context.locale.languageCode, AppConstants.patternMMMDDYYYY);
      _endDate = ref.read(EditDateAndTimeViewModel.endDateProvider);
    }

    if (ref.read(EditDateAndTimeViewModel.endTimeProvider) != null) {
      _endTimeController.text = ref.read(EditDateAndTimeViewModel.endTimeProvider)!.format(context);
      _endTime = ref.read(EditDateAndTimeViewModel.endTimeProvider);
    }
  }

  void _listener() {
    ref.listen(
        EditDateAndTimeViewModel.timezonesProvider,
        (previous, next) => next.when(
              data: (data) async {
                if (data.isNotEmpty) {
                  if (ref.read(EditDateAndTimeViewModel.selectTimezoneProvider) != null) {
                    final selectTimeZone = ref.read(EditDateAndTimeViewModel.selectTimezoneProvider);
                    final int index = data.indexWhere((element) => element.key == selectTimeZone!.key);
                    _selectTimezone = data[index];
                  } else {
                    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
                    final int index = data.indexWhere((element) => element.key == currentTimeZone);
                    _selectTimezone = data[index];
                  }
                }
              },
              error: (error, _) => navigatorKey.currentContext!.showToast(message: error.toString()),
              loading: () {},
            ));
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    return Scaffold(
      appBar: AppBarDateAndTimeEvent(
        onSaveTapped: _onSaveTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingNormal),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: AppDimens.widgetDimen16pt),

                /// Start Date
                TextFormFieldWithLabelWidget(
                  label: LocaleKeys.startDate.tr(),
                  readOnly: true,
                  onTap: () => _onStartDateTapped(),
                  controller: _startDateController,
                  validator: (value) => ValidationUtil.isValidInputField(value),
                  suffixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
                    child: CustomImage.svg(src: AppSvg.icCalendarOutline),
                  ),
                ),
                const SizedBox(height: AppDimens.widgetDimen16pt),

                /// Start Time
                TextFormFieldWithLabelWidget(
                  label: LocaleKeys.startTime.tr(),
                  readOnly: true,
                  onTap: () => _onStartTimeTapped(),
                  controller: _startTimeController,
                  validator: (value) => ValidationUtil.isValidInputField(value),
                  suffixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
                    child: CustomImage.svg(src: AppSvg.icClockOutline),
                  ),
                ),
                const SizedBox(height: AppDimens.widgetDimen16pt),
                const CustomDividerHorizontal(),
                const SizedBox(height: AppDimens.widgetDimen16pt),

                /// End Date
                TextFormFieldWithLabelWidget(
                  label: LocaleKeys.endDate.tr(),
                  readOnly: true,
                  onTap: () => _onEndDateTapped(),
                  controller: _endDateController,
                  suffixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
                    child: CustomImage.svg(src: AppSvg.icCalendarOutline),
                  ),
                ),
                const SizedBox(height: AppDimens.widgetDimen16pt),

                /// End Time
                TextFormFieldWithLabelWidget(
                  label: LocaleKeys.endTime.tr(),
                  readOnly: true,
                  validator: (value) => _endDate != null ? ValidationUtil.isValidInputField(value) : null,
                  onTap: () => _onEndTimeTapped(),
                  controller: _endTimeController,
                  suffixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
                    child: CustomImage.svg(src: AppSvg.icClockOutline),
                  ),
                ),
                const SizedBox(height: AppDimens.widgetDimen8pt),

                /// Remove Date and Time
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: CustomTextButton(
                    label: LocaleKeys.removeDateAndTime.tr(),
                    onPressed: () => _onRemoveDateTimePressed(),
                    foregroundColor: AppColors.primary,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsetsDirectional.only(
                          end: AppDimens.zero,
                          top: AppDimens.spacingSmall,
                          bottom: AppDimens.spacingSmall,
                          start: AppDimens.spacingSmall),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.widgetDimen16pt),
                const CustomDividerHorizontal(),
                const SizedBox(height: AppDimens.widgetDimen16pt),

                /// Timezone
                Consumer(
                  builder: (context, ref, child) {
                    final timezoneState = ref.watch(EditDateAndTimeViewModel.timezonesProvider);
                    return timezoneState.when(
                      data: (timezones) => DropdownButtonFormField2WithLabelWidget(
                        label: LocaleKeys.timezone.tr(),
                        value: _selectTimezone,
                        items: timezones
                            .map(
                              (timezone) => DropdownMenuItem<TimezoneModel>(
                                value: timezone,
                                child: Text(timezone.value ?? ''),
                              ),
                            )
                            .toList(),
                        disabledHint: LocaleKeys.selectTimezone.tr(),
                        maxHeightDropdown: AppDimens.widgetDimen300pt,
                        onChanged: (value) => _selectTimezone = value,
                      ),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                      loading: () => const CustomProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onEndDateTapped() {
    context.presentDatePicker(
      onDatePicked: (date) {
        _endDate = date;
        _endDateController.text = date.getFormattedDateTime(context.locale.languageCode, AppConstants.patternMMMDDYYYY);
      },
      firstDate: DateTime.now(),
      initialDate: _endDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  void _onEndTimeTapped() {
    context.presentTimePicker(
      initialTime: _endTime ?? TimeOfDay.now(),
      onTimePicked: (time) {
        _endTime = time;
        _endTimeController.text = time.format(context);
      },
    );
  }

  void _onRemoveDateTimePressed() {
    _endDateController.clear();
    _endDate = null;
    ref.read(EditDateAndTimeViewModel.endDateProvider.notifier).update(
          (state) => state = null,
        );
    _endTimeController.clear();
    _endTime = null;
    ref.read(EditDateAndTimeViewModel.endTimeProvider.notifier).update(
          (state) => state = null,
        );
  }

  void _onStartTimeTapped() {
    context.presentTimePicker(
      initialTime: _startTime ?? TimeOfDay.now(),
      onTimePicked: (time) {
        _startTime = time;
        _startTimeController.text = time.format(context);
      },
    );
  }

  void _onStartDateTapped() {
    context.presentDatePicker(
      onDatePicked: (date) {
        _startDate = date;
        _startDateController.text =
            date.getFormattedDateTime(context.locale.languageCode, AppConstants.patternMMMDDYYYY);
      },
      firstDate: DateTime.now(),
      initialDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  void _onSaveTapped() {
    if (_formKey.currentState!.validate()) {
      if (_startDate != null && _endDate != null) {
        final startDateTime = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
        final endDateTime = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
        bool isValidDate = startDateTime.isBefore(endDateTime);
        if (isValidDate) {
          _fillDateAndTimeData();
          Navigator.of(context).maybePop();
        } else {
          context.showToast(message: LocaleKeys.youCannotAddPastTimeAsAnEndTimeForTheEvent.tr());
        }
      } else {
        _fillDateAndTimeData();
        Navigator.of(context).maybePop();
      }
    }
  }

  void _fillDateAndTimeData() {
    ref.read(EditDateAndTimeViewModel.startDateProvider.notifier).state = _startDate ?? DateTime.now();
    ref.read(EditDateAndTimeViewModel.startTimeProvider.notifier).state = _startTime ?? TimeOfDay.now();
    ref.read(EditDateAndTimeViewModel.endDateProvider.notifier).state = _endDate;
    ref.read(EditDateAndTimeViewModel.endTimeProvider.notifier).state = _endTime;
    ref.read(EditDateAndTimeViewModel.selectTimezoneProvider.notifier).state = _selectTimezone;
  }
}
