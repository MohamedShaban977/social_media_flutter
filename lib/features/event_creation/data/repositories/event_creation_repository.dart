import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/event_creation/data/models/timezone_model.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/edit_event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/requests_bodies/event_request_body.dart';
import 'package:hauui_flutter/features/event_creation/data/services/event_creation_service.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';

class EventCreationRepository {
  final EventCreationService _eventCreationService;

  EventCreationRepository(this._eventCreationService);

  Future<Either<Failure, BaseResponse<EventModel>>> createEvent(EventRequestBody eventRequestBody) async {
    try {
      final response = await _eventCreationService.createEvent(eventRequestBody);
      return response.success ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<EventModel>>> editEvent(
      int eventId, EditEventRequestBody editEventRequestBody) async {
    try {
      final response = await _eventCreationService.editEvent(eventId, editEventRequestBody);
      return response.success ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<TimezoneModel>>> getLookupTimezone() async {
    try {
      final res = await _eventCreationService.getLookupTimezone();
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
