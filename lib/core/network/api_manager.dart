import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hauui_flutter/app/app_config.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/network/error_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'app_interceptor.dart';
import 'base_response.dart';
import 'status_code.dart';

abstract class BaseApiManager {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class ApiManager implements BaseApiManager {
  final Dio client;

  ApiManager({required this.client}) {
    if (!kIsWeb) {
      client.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
    client.options
      ..baseUrl = configs!.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..receiveDataWhenStatusError = true
      ..receiveTimeout = const Duration(seconds: 60)
      ..connectTimeout = const Duration(seconds: 60)
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };

    client.interceptors.add(getIt<AppInterceptors>());
    if (kDebugMode) {
      client.interceptors.add(getIt<PrettyDioLogger>());
    }
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await client.post(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(
    String path, {
    bool isFormData = false,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await client.put(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await client.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    if (response.statusCode! < StatusCode.safeZone) {
      return BaseResponse(
              success: true,
              statusCode: response.statusCode!,
              message: response.statusMessage.toString(),
              data: jsonDecode(response.data.toString()))
          .toJson();
    } else {
      _handleResponseError(response);
    }
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw FetchDataException();
      case DioExceptionType.badResponse:
        debugPrint(error.message);
        _handleResponseDioError(error);
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          throw NoInternetConnectionException(error.message);
        }
        break;
      case DioExceptionType.unknown:
        throw ErrorOtherException(message: error.message);

      case DioExceptionType.badCertificate:
        throw ConflictException();
    }
  }

  void _handleResponseDioError(DioException error) {
    switch (error.response?.statusCode) {
      case StatusCode.badRequest:
        throw BadRequestException();
      case StatusCode.unauthorized:
        throw UnauthorizedException();

      case StatusCode.forbidden:
        throw UnauthorizedException();

      case StatusCode.notFound:
        final errorResponse = ErrorResponse.fromJson(json.decode(error.response?.data));
        throw NotFoundException(errorResponse.message);
      case StatusCode.conflict:
        throw ConflictException();
      case StatusCode.unprocessableEntity:
        final errorResponse = ErrorResponse.fromJson(json.decode(error.response?.data));
        throw UnprocessableEntityException(errorResponse.message);
      case StatusCode.internalServerError:
        throw InternalServerErrorException();
      case StatusCode.movedParameter:
        throw ErrorOtherException(message: error.message);
    }
  }

  void _handleResponseError(Response<dynamic> response) {
    switch (response.statusCode) {
      case StatusCode.badRequest:
        throw BadRequestException(response.data);
      case StatusCode.unauthorized:
        throw UnauthorizedException(response.data);
      case StatusCode.forbidden:
        throw UnauthorizedException();
      case StatusCode.notFound:
        final errorResponse = ErrorResponse.fromJson(json.decode(response.data));
        throw NotFoundException(errorResponse.message);
      case StatusCode.methodNotAllowed:
        throw MethodNotAllowed();
      case StatusCode.conflict:
        throw ConflictException();
      case StatusCode.unprocessableEntity:
        final errorResponse = ErrorResponse.fromJson(json.decode(response.data));
        throw UnprocessableEntityException(errorResponse.message);
      case StatusCode.internalServerError:
        throw InternalServerErrorException();
      case StatusCode.movedParameter:
        throw ErrorOtherException(message: '${response.data}');
    }
  }
}
