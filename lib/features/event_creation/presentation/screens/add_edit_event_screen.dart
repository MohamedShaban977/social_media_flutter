import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/event_location_type.dart';
import 'package:hauui_flutter/core/constants/enums/event_screen_type.dart';
import 'package:hauui_flutter/core/constants/enums/media_type.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/managers/file_manager.dart';
import 'package:hauui_flutter/core/managers/s3_manager.dart';
import 'package:hauui_flutter/core/models/file_model.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/cell_thumbnail.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/invalid_input_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/edit_event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/hobby_level_identifiers_model.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/add_edit_event_view_model.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/edit_date_and_time_view_model.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/add_hashtags_widget.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/add_location_widget.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/app_bar_event.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/event_description_widget.dart';
import 'package:hauui_flutter/features/event_creation/presentation/widgets/event_location_type_widget.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/add_hobby_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/choose_post_level_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddEditEventScreen extends ConsumerStatefulWidget {
  final EventScreenType eventScreenType;
  final int? eventId;

  const AddEditEventScreen.add({super.key})
      : eventScreenType = EventScreenType.add,
        eventId = null;

  const AddEditEventScreen.edit({
    super.key,
    required this.eventId,
  }) : eventScreenType = EventScreenType.edit;

  @override
  ConsumerState createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends ConsumerState<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final controllerDateAndTime = TextEditingController();
  final eventLinkController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final _isLevelSelected = ValueNotifier<bool?>(null);
  final ValueNotifier<List<FileModel>> _filesMedia = ValueNotifier([]);
  List<AssetEntity> _selectedAssets = [];
  final _isHobbySelected = ValueNotifier<bool?>(null);

  final _fileManager = FileManager();

  bool _isTappedCreate = false;

  EventModel? event;

  final ValueNotifier<List<MediaModel>> _mediaAttribute = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.eventScreenType == EventScreenType.add) {
        ref.invalidate(AddEditEventViewModel.selectedEventLocationTypeProvider);
        ref.invalidate(EditDateAndTimeViewModel.startDateProvider);
        ref.invalidate(EditDateAndTimeViewModel.startTimeProvider);
        ref.invalidate(EditDateAndTimeViewModel.endDateProvider);
        ref.invalidate(EditDateAndTimeViewModel.endTimeProvider);
        ref.invalidate(EditDateAndTimeViewModel.selectTimezoneProvider);
      }
      if (widget.eventScreenType == EventScreenType.edit) {
        await _getEventDetails();

        _updateEventData();
      }

      _fillDateAndTime();
    });
  }

  Future<void> _getEventDetails() async {
    context.block(backIcon: Icons.close);
    await ref.read(EventsViewModel.eventDetailsProvider.notifier).getEventDetails(eventId: widget.eventId!);
    navigatorKey.currentContext!.unblock();
  }

  void _updateEventData() {
    event = ref.read(EventsViewModel.eventDetailsProvider).value;
    if (event != null) {
      _mediaAttribute.value = event?.mediaAttribute ?? [];

      ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider.notifier).state =
          EventLocationType.inPerson.key == event?.location ? EventLocationType.inPerson : EventLocationType.online;
      eventNameController.text = event?.title ?? '';
      controllerDateAndTime.text = LocaleKeys.selectedDateTime.tr(namedArgs: {
        'startDate': event?.startDate != null
            ? event!.startDate!.getFormattedDateTime(
                navigatorKey.currentContext!.locale.languageCode,
                AppConstants.patternMMMMDDYYYY,
              )
            : '',
        'startTime': event?.startDate != null
            ? TimeOfDay(hour: event!.startDate!.hour, minute: event!.startDate!.minute)
                .format(navigatorKey.currentContext!)
            : '',
        'endDate': event?.endDate != null
            ? event!.endDate!.getFormattedDateTime(
                navigatorKey.currentContext!.locale.languageCode,
                AppConstants.patternMMMMDDYYYY,
              )
            : '',
        'endTime': event?.endDate != null
            ? TimeOfDay(hour: event!.endDate!.hour, minute: event!.endDate!.minute).format(navigatorKey.currentContext!)
            : '',
      }).trim();
      eventLinkController.text = event?.website ?? '';
      eventDescriptionController.text = event?.description ?? '';
      if (event?.hashtags != null && event!.hashtags!.isNotEmpty) {
        ref.read(PostCreationViewModel.inputHashtagsProvider.notifier).state =
            event!.hashtags!.map((e) => LocaleKeys.hashtag.tr(args: [e.name ?? ''])).toList().join(' ');
      }
      ref.read(AddEditEventViewModel.addressDetailProvider.notifier).state =
          '${event?.address}, ${event?.addressDetails}';
      ref.read(AddEditEventViewModel.latitudeProvider.notifier).state = event?.lat;
      ref.read(AddEditEventViewModel.longitudeProvider.notifier).state = event?.long;
      ref.read(PostCreationViewModel.selectedLevelIdProvider.notifier).state = event?.level?.id;
      if (event?.hobbies != null && event!.hobbies!.isNotEmpty) {
        ref.read(PostCreationViewModel.selectedHobbiesProvider.notifier).state =
            event!.hobbies!.map((e) => e.hobby!).toList();
      }
    }
  }

  void _fillDateAndTime() {
    controllerDateAndTime.addListener(() {
      final startDate = ref.read(EditDateAndTimeViewModel.startDateProvider);
      final startTime = ref.read(EditDateAndTimeViewModel.startTimeProvider);
      final endDate = ref.read(EditDateAndTimeViewModel.endDateProvider);
      final endTime = ref.read(EditDateAndTimeViewModel.endTimeProvider);
      controllerDateAndTime.text = LocaleKeys.selectedDateTime.tr(namedArgs: {
        'startDate': startDate != null
            ? startDate.getFormattedDateTime(
                context.locale.languageCode,
                AppConstants.patternMMMMDDYYYY,
              )
            : '',
        'startTime': startTime != null ? startTime.format(context) : '',
        'endDate': endDate != null
            ? endDate.getFormattedDateTime(
                context.locale.languageCode,
                AppConstants.patternMMMMDDYYYY,
              )
            : '',
        'endTime': endTime != null ? endTime.format(context) : '',
      }).trim();
    });
  }

  @override
  void dispose() {
    eventNameController.dispose();
    controllerDateAndTime.dispose();
    eventLinkController.dispose();
    eventDescriptionController.dispose();
    _isLevelSelected.dispose();
    _isHobbySelected.dispose();
    _filesMedia.dispose();
    _mediaAttribute.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarEvent(
        title: widget.eventScreenType == EventScreenType.add ? LocaleKeys.createEvent.tr() : LocaleKeys.editEvent.tr(),
        titleAction: widget.eventScreenType == EventScreenType.add ? LocaleKeys.create.tr() : LocaleKeys.edit.tr(),
        onActionTapped: _onActionTapped,
        onBackTapped: () => _showDiscardAndExitDialog(),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// event photos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: AppDimens.spacingSmall,
                  spacing: AppDimens.spacingSmall,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _filesMedia,
                        builder: (context, files, child) {
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: AppDimens.spacingSmall,
                            spacing: AppDimens.spacingSmall,
                            children: [
                              InkWell(
                                onTap: () async => await _onOpenMediaPickerTapped(),
                                child: const CustomImage.svg(
                                  src: AppSvg.icAddPhotosGreySquared,
                                  height: AppDimens.widgetDimen59pt,
                                  width: AppDimens.widgetDimen59pt,
                                ),
                              ),
                              if (files.isNotEmpty)
                                ...List.generate(
                                  files.length,
                                  (index) => CellThumbnail(
                                    fileMedia: files[index],
                                    onDeleteTapped: () => _onDeleteFileTapped(index),
                                  ),
                                ),
                            ],
                          );
                        }),
                    ValueListenableBuilder(
                      valueListenable: _mediaAttribute,
                      builder: (context, media, child) {
                        return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: AppDimens.spacingSmall,
                            spacing: AppDimens.spacingSmall,
                            children: List.generate(
                              media.length,
                              (index) => CellThumbnail(
                                url: media[index].mediaLink,
                                onDeleteTapped: () => _onDeleteMediaTapped(index),
                              ),
                            ));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen24pt),

              /// event location type
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: EventLocationTypeWidget(
                  validateForm: () => (_isTappedCreate) ? _formKey.currentState!.validate() : null,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// event name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: TextFormFieldWithLabelWidget(
                  label: LocaleKeys.eventName.tr(),
                  hintText: LocaleKeys.writeHere.tr(),
                  controller: eventNameController,
                  validator: (value) => ValidationUtil.isValidInputField(value),
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// date and time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: TextFormFieldWithLabelWidget(
                  label: LocaleKeys.dateAndTime.tr(),
                  hintText: LocaleKeys.selectDateAndTime.tr(),
                  controller: controllerDateAndTime,
                  maxLines: 2,
                  minLines: 1,
                  validator: (value) => ValidationUtil.isValidInputField(value),
                  readOnly: true,
                  onTap: () => Navigator.of(context).pushNamed(RoutesNames.editDateAndTimeRoute),
                ),
              ),

              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// event link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: TextFormFieldWithLabelWidget(
                  label: LocaleKeys.eventLink.tr(),
                  hintText: LocaleKeys.exampleLink.tr(),
                  controller: eventLinkController,
                  validator: (value) {
                    return ValidationUtil.isValidUrl(value,
                        isInPerson: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) ==
                            EventLocationType.inPerson);
                  },
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// event destination
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: EventDescriptionWidget(
                  controller: eventDescriptionController,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen24pt),

              /// event add hashtags
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: AddHashtagsWidget(),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// add location
              Consumer(
                builder: (context, ref, child) {
                  final selectedEventLocationType = ref.watch(AddEditEventViewModel.selectedEventLocationTypeProvider);
                  return SizedBox(
                    height: selectedEventLocationType == EventLocationType.inPerson ? null : AppDimens.zero,
                    child: Column(
                      children: [
                        const CustomDividerHorizontal(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spacingNormal,
                            vertical: AppDimens.spacingNormal,
                          ),
                          child: FormField(
                              validator: (_) {
                                if (ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) ==
                                    EventLocationType.inPerson) {
                                  return ValidationUtil.isValidInputField(
                                    ref.read(AddEditEventViewModel.addressDetailProvider),
                                  );
                                } else {
                                  return null;
                                }
                              },
                              builder: (field) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const AddLocationWidget(),
                                      field.hasError
                                          ? InvalidInputWidget(errorMessage: field.errorText ?? '')
                                          : const SizedBox.shrink(),
                                    ],
                                  )),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const CustomDividerHorizontal(),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// select hobbies
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: AddHobbyWidget(
                  isHobbySelected: _isHobbySelected,
                ),
              ),

              const SizedBox(height: AppDimens.widgetDimen16pt),
              const CustomDividerHorizontal(),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// choose post level
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                child: ChoosePostLevelWidget(isLevelSelected: _isLevelSelected),
              ),

              const SizedBox(height: AppDimens.widgetDimen24pt),
            ],
          ),
        ),
      ),
    );
  }

  void _onDeleteFileTapped(int index) {
    _selectedAssets.removeAt(index);
    _filesMedia.value.removeAt(index);
    _filesMedia.value = [..._filesMedia.value];
  }

  void _onDeleteMediaTapped(int index) {
    _mediaAttribute.value.removeAt(index);
    _mediaAttribute.value = [..._mediaAttribute.value];
  }

  Future<void> _onOpenMediaPickerTapped() async {
    if (_selectedAssets.length < AppConstants.maxAssetsEvent) {
      final result = await _fileManager.pickAssets(
        context: context,
        selectedAssets: _selectedAssets,
        maxAssets: AppConstants.maxAssetsEvent - _mediaAttribute.value.length,
        requestType: RequestType.fromTypes([RequestType.image]),
      );

      if (result != null) {
        _filesMedia.value = await FileModel.fromAssetEntity(assetEntityList: result);
        _selectedAssets = result;
      }
    } else {
      context.showToast(message: LocaleKeys.maximumNumberOfSelectedImagesIs5.tr());
    }
  }

  Future<List<String>> _uploadEventImagesToS3() async {
    if (_filesMedia.value == []) return [];
    List<FileModel> photos = _filesMedia.value;
    final result = await S3Manager.uploadToS3(
      files: photos,
      onProgress: (progress) {},
    );
    return result.map((e) => e.fileUrl ?? '').toList();
  }

  bool _isLevelValid() {
    final isLevelSelected = ref.read(PostCreationViewModel.selectedLevelIdProvider) != null;
    _isLevelSelected.value = isLevelSelected;
    return isLevelSelected;
  }

  bool _isHobbyValid() {
    final isHobbySelected = ref.read(PostCreationViewModel.selectedHobbiesProvider).isNotEmpty;
    _isHobbySelected.value = isHobbySelected;
    return isHobbySelected;
  }

  Future<void> _onActionTapped() async {
    _isTappedCreate = true;
    if (_formKey.currentState!.validate() & _isLevelValid() & _isHobbyValid()) {
      context.block(backIcon: Icons.close);
      final filesUrl = await _uploadEventImagesToS3();
      if (widget.eventScreenType == EventScreenType.add) {
        await AddEditEventViewModel.createEvent(
          eventRequestBody: _fillEventRequestBody(filesUrl),
          onSuccess: (data) => Navigator.of(context).pop(),
          onFail: (errorMassage) {
            context.showToast(message: errorMassage);
          },
        );
      }

      if (widget.eventScreenType == EventScreenType.edit) {
        await AddEditEventViewModel.editEvent(
          eventId: event!.id!,
          editEventRequestBody: _fillEditEventRequestBody(filesUrl),
          onSuccess: (data) {
            ref.read(EventsViewModel.eventDetailsProvider.notifier).state = AsyncValue.data(data);
            Navigator.of(context)
              ..pop()
              ..pop();
          },
          onFail: (errorMassage) {
            context.showToast(message: errorMassage);
          },
        );
      }
      if (mounted) {
        context.unblock();
      }
    }
  }

  EventRequestBody _fillEventRequestBody(List<String>? filesUrl) {
    return EventRequestBody(
      title: eventNameController.text,
      description: eventDescriptionController.text,
      startDate: _fillDateTime(
        date: ref.read(EditDateAndTimeViewModel.startDateProvider),
        time: ref.read(EditDateAndTimeViewModel.startTimeProvider),
      ),
      endDate: _fillDateTime(
        date: ref.read(EditDateAndTimeViewModel.endDateProvider),
        time: ref.read(EditDateAndTimeViewModel.endTimeProvider),
      ),
      timezone: ref.read(EditDateAndTimeViewModel.selectTimezoneProvider)?.key,
      addressDetails: ref.read(AddEditEventViewModel.addressDetailProvider),
      address: ref.read(AddEditEventViewModel.addressProvider),
      lat: ref.read(AddEditEventViewModel.latitudeProvider),
      long: ref.read(AddEditEventViewModel.longitudeProvider),
      location: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider).key,
      website: eventLinkController.text.isNotEmpty ? eventLinkController.text : null,
      hashtags: _fillHashtags(),
      hobbies: _fillHobbits(),
      mediaAttributes: _fillMediaAttributes(filesUrl),
    );
  }

  EditEventRequestBody _fillEditEventRequestBody(List<String>? filesUrl) {
    return EditEventRequestBody(
      title: eventNameController.text,
      description: eventDescriptionController.text,
      startDate: _fillDateTime(
        date: ref.read(EditDateAndTimeViewModel.startDateProvider),
        time: ref.read(EditDateAndTimeViewModel.startTimeProvider),
      ),
      timezone: ref.read(EditDateAndTimeViewModel.selectTimezoneProvider)?.key,
      address: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) == EventLocationType.inPerson
          ? ref.read(AddEditEventViewModel.addressProvider)
          : null,
      addressDetails: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) == EventLocationType.inPerson
          ? ref.read(AddEditEventViewModel.addressDetailProvider)
          : null,
      lat: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) == EventLocationType.inPerson
          ? ref.read(AddEditEventViewModel.latitudeProvider)
          : null,
      long: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider) == EventLocationType.inPerson
          ? ref.read(AddEditEventViewModel.longitudeProvider)
          : null,
      location: ref.read(AddEditEventViewModel.selectedEventLocationTypeProvider).number,
      website: eventLinkController.text.isNotEmpty ? eventLinkController.text : null,
      hashtags: _fillHashtags(),
      hobbies: _fillHobbits(),
      mediaAttributes: _collectMediaFiles(filesUrl),
    );
  }

  DateTime? _fillDateTime({DateTime? date, TimeOfDay? time}) {
    if (date != null && time != null) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    } else {
      return null;
    }
  }

  List<HashtagModel>? _fillHashtags() {
    final List<String> hashtags = ref.read(PostCreationViewModel.inputHashtagsProvider).replaceAll('#', '').split(' ');
    final List<HashtagModel> result = [];
    for (final String tag in hashtags) {
      if (tag.trim().isNotEmpty) {
        result.add(
          HashtagModel(
            name: tag.trim(),
          ),
        );
      }
    }
    if (result.isNotEmpty) {
      return result;
    } else {
      return null;
    }
  }

  List<HobbyLevelIdentifiersModel>? _fillHobbits() {
    final selectLevelId = ref.read(PostCreationViewModel.selectedLevelIdProvider);
    final selectHobbies = ref.read(PostCreationViewModel.selectedHobbiesProvider);
    final List<HobbyLevelIdentifiersModel> result = [];

    if (selectLevelId == null || selectHobbies.isEmpty) return null;

    for (final HobbyModel hobby in selectHobbies) {
      result.add(
        HobbyLevelIdentifiersModel(
          hobbyId: hobby.id!,
          levelId: selectLevelId,
        ),
      );
    }

    if (result.isNotEmpty) {
      return result;
    } else {
      return null;
    }
  }

  List<MediaModel>? _fillMediaAttributes(List<String>? filesUrl) {
    if (filesUrl == null) return null;
    return filesUrl
        .map(
          (e) => MediaModel(
            mediaLink: e,
            mediaType: MediaType.image,
          ),
        )
        .toList();
  }

  List<MediaModel>? _collectMediaFiles(List<String>? filesUrl) {
    final media = [
      ..._mediaAttribute.value.map(
        (e) => MediaModel(
          mediaLink: e.mediaLink,
          mediaType: e.mediaType,
        ),
      ),
      ...filesUrl!.map(
        (e) => MediaModel(
          mediaLink: e,
          mediaType: MediaType.image,
        ),
      ),
    ];
    return media;
  }

  void _showDiscardAndExitDialog() {
    if (eventNameController.text.isNotEmpty ||
        controllerDateAndTime.text.isNotEmpty ||
        eventLinkController.text.isNotEmpty ||
        eventDescriptionController.text.isNotEmpty ||
        _filesMedia.value.isNotEmpty ||
        _isLevelSelected.value != null ||
        _isHobbySelected.value != null ||
        ref.read(AddEditEventViewModel.addressDetailProvider) != null) {
      context.showAdaptiveDialog(
        content: LocaleKeys.areYouSureYouWantToDiscardThisEventCreation.tr(),
        cancelable: true,
        positiveBtnName: LocaleKeys.yes.tr(),
        negativeBtnName: LocaleKeys.no.tr(),
        positiveBtnAction: () async => Navigator.of(context).pop(),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
