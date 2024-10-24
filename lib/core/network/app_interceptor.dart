import 'package:dio/dio.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';

import 'headers_util.dart';
import 'status_code.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    final headersUtil = HeadersUtil();

    options.headers.addEntries(headersUtil.getHeader().entries);

    /*logger.d(
      'REQUEST[${options.method}] => Headers: ${options.headers}',
    );*/

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // if (response.statusCode == StatusCode.badRequest) {
    //   var error = jsonDecode(response.data);
    //   // ToastAndSnackBar.showSnackBarFailure(MagicRouter.currentContext!,
    //   //     title: response.statusMessage!, message: error['title']!);
    // }

    if (response.statusCode == StatusCode.unauthorized) {}

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    logger.e(
      'ERROR[${err.type}] => Error: ${err.error}',
    );

    if (err.type == DioExceptionType.unknown) {
      // MagicRouterName.navigateTo(RoutesNames.loginRoute);
    }

    return super.onError(err, handler);
  }
}
