import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/data/models/joiners_event_model.dart';

class EventService {
  final ApiManager _apiManager;

  EventService(this._apiManager);

  Future<BaseCollectionResponse<EventModel>> getEventForYou(int pageNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiEventForMe,
      queryParameters: {
        ApiConstants.page: pageNumber,
        ApiConstants.perPage: ApiConstants.defaultPageSize,
      },
    );

    return BaseCollectionResponse.fromJson(response, (item) => EventModel.fromJson(item));
  }

  Future<BaseCollectionResponse<EventModel>> getYourEvent(String scope, int pageNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiMyEvent,
      queryParameters: {
        'scope': scope,
        ApiConstants.page: pageNumber,
        ApiConstants.perPage: ApiConstants.defaultPageSize,
      },
    );

    return BaseCollectionResponse.fromJson(response, (item) => EventModel.fromJson(item));
  }

  Future<BaseCollectionResponse<EventModel>> getDiscoverEvent(double lat, double long, int pageNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiDiscoverEvent,
      queryParameters: {
        'lat': lat,
        'long': long,
        'filter': 1,
        /*no clue what this is for*/
        ApiConstants.page: pageNumber,
        ApiConstants.perPage: ApiConstants.defaultPageSize,
      },
    );

    return BaseCollectionResponse.fromJson(response, (item) => EventModel.fromJson(item));
  }

  Future<BaseResponse<EventModel>> getEventDetails(int eventId) async {
    final response = await _apiManager.get(ApiConstants.apiEventDetails(eventId));

    return BaseResponse.fromJson(response, (item) => EventModel.fromJson(item));
  }

  Future<BaseCollectionResponse<EventModel>> getYouMayLikeEvent(int eventId, int pageNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiEventYouMayLike(eventId),
      queryParameters: {
        ApiConstants.page: pageNumber,
        ApiConstants.perPage: ApiConstants.defaultPageSize,
      },
    );

    return BaseCollectionResponse.fromJson(response, (item) => EventModel.fromJson(item));
  }

  Future<BaseResponse<SuccessMessageModel>> joinEvent(
    String eventId,
  ) async {
    final response = await _apiManager.post(
      ApiConstants.apiJoinOrLeaveEvent(eventId),
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> leaveEvent(String eventId, String userId) async {
    final response = await _apiManager.delete(
      ApiConstants.apiJoinOrLeaveEvent(eventId, userId),
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> saveUnsaveEvent(int eventId) async {
    final response = await _apiManager.post(
      ApiConstants.apiSaveUnsaveEvent,
      data: {
        'event_id': eventId,
      },
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> deleteEvent(int eventId) async {
    final response = await _apiManager.delete(
      ApiConstants.apiDeleteEvent(eventId),
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> hiddenEvents(int eventId) async {
    final response = await _apiManager.post(
      ApiConstants.apihiddenEvents,
      data: {
        'event_id': eventId,
      },
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseCollectionResponse<IntKeyStingValueModel>> getReportReasonEvent() async {
    final response = await _apiManager.get(ApiConstants.apiReportReasonsEvent);

    return BaseCollectionResponse.fromJson(response, (item) => IntKeyStingValueModel.fromJson(item));
  }

  Future<BaseResponse<SuccessMessageModel>> reportedEvents(int reportReasonId, int eventId) async {
    final response = await _apiManager.post(
      ApiConstants.apiReportedEvents,
      data: {
        'event_id': eventId,
        "report_reason_id": reportReasonId,
      },
    );

    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<JoinersEventModel>> getJoinersEvent(int eventId, int pageNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiJoinersEvent(eventId),
      queryParameters: {
        ApiConstants.page: pageNumber,
        ApiConstants.perPage: ApiConstants.defaultPageSize,
      },
    );

    return BaseResponse.fromJson(response, (item) => JoinersEventModel.fromJson(item));
  }
}
