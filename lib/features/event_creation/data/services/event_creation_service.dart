import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/event_creation/data/models/timezone_model.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/edit_event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/event_request_body.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';

class EventCreationService {
  final ApiManager _apiManager;

  EventCreationService(this._apiManager);

  Future<BaseResponse<EventModel>> createEvent(EventRequestBody eventRequestBody) async {
    final response = await _apiManager.post(
      ApiConstants.apiCreateEvent,
      data: eventRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => EventModel.fromJson(data),
    );
  }

  Future<BaseResponse<EventModel>> editEvent(int eventId, EditEventRequestBody editEventRequestBody) async {
    final response = await _apiManager.put(
      ApiConstants.apiEditEvent(eventId),
      data: editEventRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => EventModel.fromJson(data),
    );
  }

  Future<BaseCollectionResponse<TimezoneModel>> getLookupTimezone() async {
    final response = await _apiManager.get(ApiConstants.apiTimezones);

    return BaseCollectionResponse.fromJson(response, (item) => TimezoneModel.fromJson(item));
  }
}
