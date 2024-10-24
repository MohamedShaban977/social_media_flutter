import 'package:dio/dio.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/app_interceptor.dart';
import 'package:hauui_flutter/core/repositories/s3_repository.dart';
import 'package:hauui_flutter/core/services/s3_service.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/repositories/forget_password_repository.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/services/forget_password_service.dart';
import 'package:hauui_flutter/features/authentication/login/data/repositories/login_repository.dart';
import 'package:hauui_flutter/features/authentication/login/data/services/login_service.dart';
import 'package:hauui_flutter/features/authentication/register/data/repositories/register_repository.dart';
import 'package:hauui_flutter/features/authentication/register/data/services/register_service.dart';
import 'package:hauui_flutter/features/authentication/verification/data/repositories/verification_repository.dart';
import 'package:hauui_flutter/features/authentication/verification/data/services/verification_service.dart';
import 'package:hauui_flutter/features/event_creation/data/repositories/event_creation_repository.dart';
import 'package:hauui_flutter/features/event_creation/data/services/event_creation_service.dart';
import 'package:hauui_flutter/features/events/data/repositories/event_repository.dart';
import 'package:hauui_flutter/features/events/data/services/event_service.dart';
import 'package:hauui_flutter/features/main_layout/data/repositories/check_update_version_repository.dart';
import 'package:hauui_flutter/features/main_layout/data/services/check_update_version_service.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';
import 'package:hauui_flutter/features/on_boarding/data/services/on_boarding_service.dart';
import 'package:hauui_flutter/features/post_creation/data/repositories/post_creation_repository.dart';
import 'package:hauui_flutter/features/post_creation/data/services/post_creation_service.dart';
import 'package:hauui_flutter/features/posts/data/repositories/posts_repository.dart';
import 'package:hauui_flutter/features/posts/data/repositories/vimeo_repository.dart';
import 'package:hauui_flutter/features/posts/data/services/posts_service.dart';
import 'package:hauui_flutter/features/profile/data/repositories/profile_repository.dart';
import 'package:hauui_flutter/features/profile/data/services/profile_service.dart';
import 'package:hauui_flutter/features/posts/data/services/vimeo_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ServiceLocator {
  void init() {
    /// Dio
    getIt.registerLazySingleton<Dio>(
      () => Dio(),
    );

    getIt.registerLazySingleton<Dio>(
      () => Dio(),
      instanceName: AppConstants.instanceNameDioS3,
    );

    getIt.registerLazySingleton<AppInterceptors>(
      () => AppInterceptors(),
    );
    getIt.registerLazySingleton<PrettyDioLogger>(
      () => PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );

    /// Api Manager
    getIt.registerLazySingleton<ApiManager>(
      () => ApiManager(
        client: getIt(),
      ),
    );

    /// Services
    getIt.registerLazySingleton<PostsService>(
      () => PostsService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<LoginService>(
      () => LoginService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<RegisterService>(
      () => RegisterService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<ForgetPasswordService>(
      () => ForgetPasswordService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<VerificationService>(
      () => VerificationService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<OnboardingService>(
      () => OnboardingService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<CheckUpdateVersionService>(
      () => CheckUpdateVersionService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<VimeoService>(
      () => VimeoService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<PostCreationService>(
      () => PostCreationService(
        getIt(),
      ),
    );

    getIt.registerLazySingleton<EventService>(
      () => EventService(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<EventCreationService>(
      () => EventCreationService(
        getIt(),
      ),
    );

    getIt.registerLazySingleton<S3Service>(
      () => S3Service(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<ProfileService>(
      () => ProfileService(
        getIt(),
      ),
    );

    /// Repositories
    getIt.registerLazySingleton<PostsRepository>(
      () => PostsRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<RegisterRepository>(
      () => RegisterRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<ForgetPasswordRepository>(
      () => ForgetPasswordRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<VerificationRepository>(
      () => VerificationRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<CheckUpdateVersionRepository>(
      () => CheckUpdateVersionRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<VimeoRepository>(
      () => VimeoRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<PostCreationRepository>(
      () => PostCreationRepository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<EventCreationRepository>(
      () => EventCreationRepository(
        getIt(),
      ),
    );

    getIt.registerLazySingleton<EventRepository>(
      () => EventRepository(
        getIt(),
      ),
    );

    getIt.registerLazySingleton<S3Repository>(
      () => S3Repository(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(
        getIt(),
      ),
    );
  }
}
