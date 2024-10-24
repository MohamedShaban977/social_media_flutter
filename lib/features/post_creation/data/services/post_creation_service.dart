import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';

class PostCreationService {
  final ApiManager _apiManager;

  PostCreationService(this._apiManager);

  Future<BaseCollectionResponse<HashtagModel>> getSuggestedHashtags({
    required int pageNumber,
    required String keyWord,
  }) async {
    final response = await _apiManager.get(
      ApiConstants.apiGetSuggestedHashtags,
      queryParameters: {
        ApiConstants.perPage: ApiConstants.defaultPageSize,
        ApiConstants.page: pageNumber,
        'search_key': keyWord,
      },
    );
    return BaseCollectionResponse.fromJson(
      response,
      (data) => HashtagModel.fromJson(
        data,
      ),
    );
  }
}
