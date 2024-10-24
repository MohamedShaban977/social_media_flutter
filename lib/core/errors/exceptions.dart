import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ServerException implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  String toString() => '$message';
}

class FetchDataException extends ServerException {
  FetchDataException([message]) : super(LocaleKeys.errorDuringCommunication.tr(args: [message ?? '']));
}

class BadRequestException extends ServerException {
  BadRequestException([message]) : super(LocaleKeys.badRequest.tr(args: [message ?? '']));
}

class UnauthorizedException extends ServerException {
  UnauthorizedException([message]) : super(LocaleKeys.unauthorized.tr(args: [message ?? '']));
}

class MethodNotAllowed extends ServerException {
  MethodNotAllowed([message]) : super(LocaleKeys.methodNotAllowed.tr(args: [message ?? '']));
}

class NotFoundException extends ServerException {
  NotFoundException([message]) : super(LocaleKeys.requestedInfoNotFound.tr(args: [message ?? '']));
}

class ConflictException extends ServerException {
  ConflictException([message]) : super(LocaleKeys.conflictOccurred.tr(args: [message ?? '']));
}

class UnprocessableEntityException extends ServerException {
  UnprocessableEntityException([message]) : super(message ?? '');
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException([message]) : super(LocaleKeys.internalServerError.tr(args: [message ?? '']));
}

class NoInternetConnectionException extends ServerException {
  NoInternetConnectionException([message]) : super(LocaleKeys.noInternetConnection.tr(args: [message ?? '']));
}

class ErrorOtherException extends ServerException {
  ErrorOtherException({required String? message}) : super(LocaleKeys.errorOtherException.tr(args: [message ?? '']));
}

class CacheException implements Exception {}
