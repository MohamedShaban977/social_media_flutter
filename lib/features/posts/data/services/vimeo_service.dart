import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';

class VimeoService {
  final ApiManager _apiManager;

  VimeoService(this._apiManager);

  Future<BaseResponse<Map<String, dynamic>>> getVimeoThumbnail({required String videoId}) async {
    final response = await _apiManager.get(ApiConstants.apiVimeoThumbnail(videoId));
    return BaseResponse.fromJson(response);
  }
}
