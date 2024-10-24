import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/change_city_mode.dart';
import 'package:hauui_flutter/core/constants/enums/permission_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/permissions_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/cell_suggest_place.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/add_edit_event_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'events_view_model.dart';

class ChangeCityScreen extends ConsumerStatefulWidget {
  const ChangeCityScreen.listEvent({super.key}) : changeCityMode = ChangeCityMode.listEvents;

  const ChangeCityScreen.createEvent({super.key}) : changeCityMode = ChangeCityMode.createEvent;

  final ChangeCityMode changeCityMode;

  @override
  ConsumerState<ChangeCityScreen> createState() => _ChangeCityScreenState();
}

class _ChangeCityScreenState extends ConsumerState<ChangeCityScreen> with WidgetsBindingObserver {
  final _controller = TextEditingController();

  final _locationUtil = const LocationUtil();
  bool _shouldRecallGetCurrentLocation = false;
  StreamSubscription<ServiceStatus>? _locationServiceStatusStreamSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRecallGetCurrentLocation) {
      _shouldRecallGetCurrentLocation = false;
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_locationServiceStatusStreamSubscription != null) {
      LocationUtil.cancelLocationServiceListener(
        locationServiceStatusStreamSubscription: _locationServiceStatusStreamSubscription!,
        onError: (error) => context.showToast(
          message: error.toString(),
        ),
      );
    }
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.changeCityMode == ChangeCityMode.listEvents
                  ? LocaleKeys.changeCity.tr()
                  : LocaleKeys.addLocation.tr(),
            ),
            leading: InkWell(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(Icons.arrow_back_ios),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(AppDimens.widgetDimen4pt),
              child: CustomDividerHorizontal(),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: AppDimens.widgetDimen16pt),
              GooglePlaceAutoCompleteTextField(
                textEditingController: _controller,
                googleAPIKey: AppConstants.googleAPIKey,
                inputDecoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: AppDimens.spacingNormal,
                      end: AppDimens.spacingSmall,
                    ),
                    child: CustomImage.svg(src: AppSvg.icSearch),
                  ),
                  prefixIconConstraints: BoxConstraints(maxHeight: AppDimens.widgetDimen55pt),
                ),
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  _onLocationGranted(
                    latLng: LatLng(
                      double.parse(prediction.lat ?? '0.0'),
                      double.parse(prediction.lng ?? '0.0'),
                    ),
                  );
                },
                itemClick: (Prediction prediction) => _controller.text = prediction.description ?? '',
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    color: AppColors.white,
                    child: CellSuggestPlace(
                      title: prediction.description ?? '-',
                    ),
                  );
                },
                seperatedBuilder: const CustomDividerHorizontal(),
                boxDecoration: const BoxDecoration(),
                containerHorizontalPadding: AppDimens.spacingNormal,
              ),
              InkWell(
                onTap: () => _getCurrentLocation(),
                child: CellSuggestPlace(
                  title: LocaleKeys.yourCurrentLocation.tr(),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _getCurrentLocation() async {
    await _locationUtil.getCurrentLocation(
      onLocationGranted: (latLng) => _onLocationGranted(latLng: latLng),
      onLocationDeniedForever: _onLocationDeniedForever,
      onLocationServiceDisabled: _onLocationServiceDisabled,
    );
  }

  void _onLocationGranted({required LatLng latLng}) {
    if (widget.changeCityMode == ChangeCityMode.listEvents) {
      EventsViewModel.onLocationGranted(ref: ref, latLng: latLng);
    } else if (widget.changeCityMode == ChangeCityMode.createEvent) {
      AddEditEventViewModel.onLocationGranted(ref: ref, latLng: latLng);
    }
    logger.i('Location is granted: ${latLng.toJson()}');

    Navigator.of(navigatorKey.currentContext!).pop();
  }

  Future<void> _onLocationDeniedForever() async {
    context
        .showBottomSheet(
      widget: PermissionsBottomSheet(
        requiredPermissions: const [
          PermissionType.location,
        ],
      ),
    )
        .then(
      (isAppSettingsScreenOpened) {
        if (isAppSettingsScreenOpened != null) {
          _shouldRecallGetCurrentLocation = isAppSettingsScreenOpened;
        }
      },
    );
  }

  void _onLocationServiceDisabled() {
    context.showAdaptiveDialog(
      title: LocaleKeys.forBetterExperienceTurnOnDeviceLocation.tr(),
      negativeBtnName: LocaleKeys.noThanks.tr(),
      positiveBtnName: LocaleKeys.openSettings.tr(),
      positiveBtnAction: () async {
        await _openSettingsPressed();
      },
    );
  }

  Future<void> _openSettingsPressed() async {
    _locationServiceStatusStreamSubscription = await _locationUtil.openLocationSettings(
      onAndroidLocationServiceEnabled: (latLng) => _onLocationGranted(latLng: latLng),
      onIOSLocationServiceEnabled: () async => await _getCurrentLocation(),
    );
  }
}
