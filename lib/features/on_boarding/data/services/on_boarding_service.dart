import 'package:hauui_flutter/core/models/city_model.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/models/user_hobbies_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/filter_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/suggest_hobby_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/user_hobbies_request_body.dart';

class OnboardingService {
  final ApiManager _apiManager;

  OnboardingService(this._apiManager);

  Future<BaseCollectionResponse<IntKeyStingValueModel>> getLevelsList() async {
    final response = await _apiManager.get(ApiConstants.apiLevels);

    return BaseCollectionResponse.fromJson(
      response,
      (data) => IntKeyStingValueModel.fromJson(data),
    );
  }

  Future<BaseCollectionResponse<UserHobbiesModel>> getUserHobbies() async {
    final user = UserExtensions.getCachedUser();

    final response = await _apiManager.get(
      ApiConstants.apiUserHobbies('${user?.id ?? ''}'),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (data) => UserHobbiesModel.fromJson(data),
    );
  }

  Future<BaseCollectionResponse<HobbyModel>> getHobbiesList(FilterRequestBody filterRequestBody) async {
    final response = await _apiManager.get(ApiConstants.apiHobbies, queryParameters: filterRequestBody.toJson());

    return BaseCollectionResponse.fromJson(
      response,
      (data) => HobbyModel.fromJson(data),
    );
  }

  Future<BaseResponse<String>> addUserHobbies(UserHobbiesRequestBody userHobbiesRequestBody) async {
    final user = UserExtensions.getCachedUser();
    final response = await _apiManager.post(
        ApiConstants.apiUserHobbies(
          '${user?.id ?? ''}',
        ),
        data: userHobbiesRequestBody.toJson());

    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(data).message ?? '',
    );
  }

  Future<BaseCollectionResponse<HobbyModel>> getSuggestHobbies(FilterRequestBody filterRequestBody) async {
    final response = await _apiManager.get(
      ApiConstants.apiSuggestHobbiesList,
      queryParameters: filterRequestBody.toJson(),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (data) => HobbyModel.fromJson(data),
    );
  }

  Future<BaseResponse<String>> addSuggestedHobbies(SuggestHobbyRequestBody suggestHobbyRequestBody) async {
    final response = await _apiManager.post(
      ApiConstants.apiSuggestedHobbies,
      data: suggestHobbyRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(data).message ?? '',
    );
  }

  Future<BaseCollectionResponse<IntKeyStingValueModel>> getCountriesList(int? pageNumber, String? searchKey) async {
    final response = await _apiManager.get(
      ApiConstants.apiCountries,
      queryParameters:
          FilterRequestBody(page: pageNumber, perPage: ApiConstants.defaultPageSize, searchKey: searchKey).toJson(),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (data) => IntKeyStingValueModel.fromJson(data),
    );
  }

  Future<BaseCollectionResponse<CityModel>> getCitiesByCountry(
      int countryId, int? pageNumber, String? searchKey) async {
    final response = await _apiManager.get(
      ApiConstants.apiCitiesByCountry(countryId),
      queryParameters: FilterRequestBody(
        page: pageNumber ?? ApiConstants.firstPage,
        perPage: ApiConstants.defaultPageSize,
        searchKey: searchKey,
      ).toJson(),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (data) => CityModel.fromJson(data),
    );
  }

  Future<BaseResponse<UserModel>> updateProfileCity(int cityId) async {
    final response = await _apiManager.put(
      ApiConstants.apiUpdateProfileCity(UserExtensions.getCachedUser()?.id),
      data: {
        "city_id": cityId,
      },
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data),
    );
  }

  Future<BaseCollectionResponse<UserModel>> getTopUsers(FilterRequestBody filterRequestBody) async {
    final response = await _apiManager.get(
      ApiConstants.apiUsers,
      queryParameters: filterRequestBody.toJson(),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data),
    );
  }

  Future<BaseResponse<String>> followUser(int followedId) async {
    final response = await _apiManager.post(
      ApiConstants.apiFollowings(UserExtensions.getCachedUser()?.id),
      data: {
        "followed_id": followedId,
      },
    );

    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(data).message ?? '',
    );
  }

  Future<BaseResponse<String>> unfollowUser(int unfollowedId) async {
    final response = await _apiManager.delete(
      ApiConstants.apiFollowings(UserExtensions.getCachedUser()?.id, unfollowedId: unfollowedId),
    );

    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(data).message ?? '',
    );
  }
}
