import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/data/models/joiners_event_model.dart';
import 'package:hauui_flutter/features/events/data/services/event_service.dart';

class EventRepository {
  final EventService _eventService;

  EventRepository(this._eventService);

  Future<Either<Failure, BaseCollectionResponse<EventModel>>> getEventForYou(int pageNumber) async {
    try {
      final res = await _eventService.getEventForYou(pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<EventModel>>> getYourEvent(String scope, int pageNumber) async {
    try {
      final res = await _eventService.getYourEvent(scope, pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<EventModel>>> getDiscoverEvent(
      double lat, double long, int pageNumber) async {
    try {
      final res = await _eventService.getDiscoverEvent(lat, long, pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<EventModel>>> getEventDetails(int eventId) async {
    try {
      final res = await _eventService.getEventDetails(eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<EventModel>>> getYouMayLikeEvent(int eventId, int pageNumber) async {
    try {
      final res = await _eventService.getYouMayLikeEvent(eventId, pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> joinEvent(String eventId) async {
    try {
      final res = await _eventService.joinEvent(eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> leaveEvent(String eventId, String userId) async {
    try {
      final res = await _eventService.leaveEvent(eventId, userId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> saveUnsaveEvent(int eventId) async {
    try {
      final res = await _eventService.saveUnsaveEvent(eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> deleteEvent(int eventId) async {
    try {
      final res = await _eventService.deleteEvent(eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> hiddenEvents(int eventId) async {
    try {
      final res = await _eventService.hiddenEvents(eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<IntKeyStingValueModel>>> getReportReasonEvent() async {
    try {
      final res = await _eventService.getReportReasonEvent();
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> reportedEvents(int reportReasonId, int eventId) async {
    try {
      final res = await _eventService.reportedEvents(reportReasonId, eventId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<JoinersEventModel>>> getJoinersEvent(int eventId, int pageNumber) async {
    try {
      final res = await _eventService.getJoinersEvent(eventId, pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
