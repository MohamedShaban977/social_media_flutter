import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/login/data/models/rank_model.dart';

class ProfileService {
  final ApiManager _apiManager;

  ProfileService(
    this._apiManager,
  );

  Future<BaseResponse<UserModel>> getProfile({
    required int userId,
  }) async {
    final response = await _apiManager.get(
      ApiConstants.apiGetProfile(
        userId,
      ),
    );
    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(
        data,
      ),
    );
  }

  Future<BaseCollectionResponse<RankModel>> getRanks() async {
    final response = await _apiManager.get(
      ApiConstants.apiGetRanks,
    );
    return BaseCollectionResponse.fromJson(
      response,
      (data) => RankModel.fromJson(
        data,
      ),
    );
  }
}
