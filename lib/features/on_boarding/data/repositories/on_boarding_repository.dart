import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/city_model.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/on_boarding/data/models/user_hobbies_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/filter_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/suggest_hobby_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/user_hobbies_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/services/on_boarding_service.dart';

class OnboardingRepository {
  final OnboardingService _onBoardingService;

  OnboardingRepository(this._onBoardingService);

  Future<Either<Failure, BaseCollectionResponse<IntKeyStingValueModel>>> getLevelsList() async {
    try {
      final response = await _onBoardingService.getLevelsList();

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<UserHobbiesModel>>> getUserHobbies() async {
    try {
      final response = await _onBoardingService.getUserHobbies();

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<HobbyModel>>> getHobbiesList(
      {required FilterRequestBody filterRequestBody}) async {
    try {
      final response = await _onBoardingService.getHobbiesList(filterRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<String>>> addUserHobbies(UserHobbiesRequestBody userHobbiesRequestBody) async {
    try {
      final response = await _onBoardingService.addUserHobbies(userHobbiesRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<HobbyModel>>> getSuggestHobbies(
      FilterRequestBody filterRequestBody) async {
    try {
      final response = await _onBoardingService.getSuggestHobbies(filterRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<String>>> addSuggestHobbies(
      SuggestHobbyRequestBody suggestHobbyRequestBody) async {
    try {
      final response = await _onBoardingService.addSuggestedHobbies(suggestHobbyRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<IntKeyStingValueModel>>> getCountriesList(
      int? pageNumber, String? searchKey) async {
    try {
      final response = await _onBoardingService.getCountriesList(pageNumber, searchKey);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<CityModel>>> getCitiesByCountry(
      int countryId, int? pageNumber, String? searchKey) async {
    try {
      final response = await _onBoardingService.getCitiesByCountry(countryId, pageNumber, searchKey);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<UserModel>>> updateProfileCity(int cityId) async {
    try {
      final response = await _onBoardingService.updateProfileCity(cityId);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<UserModel>>> getTopUsers(FilterRequestBody filterRequestBody) async {
    try {
      final response = await _onBoardingService.getTopUsers(filterRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<String>>> followUser(int followedId) async {
    try {
      final response = await _onBoardingService.followUser(followedId);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<String>>> unfollowUser(int unfollowedId) async {
    try {
      final response = await _onBoardingService.unfollowUser(unfollowedId);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
