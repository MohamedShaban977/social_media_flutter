import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

abstract class Failure {
  final String? error;

  const Failure([this.error]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.error]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.error]);
}

class HandleFailure {
  static String mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.error!;
      case const (CacheFailure):
        return LocaleKeys.cacheFailure.tr();
      default:
        return LocaleKeys.unExpectedError.tr();
    }
  }
}
