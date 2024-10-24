import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/main_layout/data/models/check_update_model.dart';

class CheckUpdateVersionService {
  final ApiManager _apiManager;

  CheckUpdateVersionService(this._apiManager);

  Future<BaseResponse<CheckUpdateModel>> checkUpdateVersion(String platform, String buildNumber) async {
    final response = await _apiManager.get(
      ApiConstants.apiCheckForceUpdate,
      headers: {
        "platform": platform,
        "build-number": buildNumber,
      },
    );

    return BaseResponse.fromJson(
      response,
      (data) => CheckUpdateModel.fromJson(data),
    );
  }
}
