import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/event_location_type.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/features/event_creation/data/repositories/event_creation_repository.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/edit_event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/event_request_body.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';

class AddEditEventViewModel {
  static final selectedEventLocationTypeProvider = StateProvider<EventLocationType>((ref) => EventLocationType.online);
  static final addressDetailProvider = StateProvider<String?>((ref) => null);
  static final addressProvider = StateProvider<String?>((ref) => null);
  static final latitudeProvider = StateProvider<double?>((ref) => null);
  static final longitudeProvider = StateProvider<double?>((ref) => null);

  static Future<void> onLocationGranted({required WidgetRef ref, required LatLng latLng}) async {
    const locationUtil = LocationUtil();

    Placemark? address = await locationUtil.getAddressFromLatLng(
      latLng.latitude,
      latLng.longitude,
    );

    ref.read(AddEditEventViewModel.latitudeProvider.notifier).update(
          (state) => state = latLng.latitude,
        );
    ref.read(AddEditEventViewModel.longitudeProvider.notifier).update(
          (state) => state = latLng.longitude,
        );
    String addressDetail =
        '${address?.street},  ${address?.subLocality}, ${address?.locality}, ${address?.subAdministrativeArea}, ${address?.administrativeArea}, ${address?.country}';

    ref.read(AddEditEventViewModel.addressDetailProvider.notifier).state = addressDetail;
    ref.read(AddEditEventViewModel.addressProvider.notifier).state = address?.name;
  }

  static Future<void> createEvent({
    required EventRequestBody eventRequestBody,
    required void Function(EventModel event) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventCreationRepository>().createEvent(eventRequestBody);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess(response.data!),
    );
  }

  static Future<void> editEvent({
    required int eventId,
    required EditEventRequestBody editEventRequestBody,
    required void Function(EventModel event) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventCreationRepository>().editEvent(eventId, editEventRequestBody);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess(response.data!),
    );
  }
}
