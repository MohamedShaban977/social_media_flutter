import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';

class PostsService {
  final ApiManager _apiManager;

  PostsService(this._apiManager);

  Future<BaseCollectionResponse<PostModel>> getPostsList({
    required int pageNumber,
    int? eventId,
    int? hobbyId,
    int? userId,
  }) async {
    final response = await _apiManager.get(
      ApiConstants.apiPosts,
      queryParameters: {
        ApiConstants.perPage: ApiConstants.defaultPageSize,
        ApiConstants.page: pageNumber,
        if (eventId != null) "event_id": eventId,
        if (hobbyId != null) "hobby_id": hobbyId,
        if (userId != null) "user_id": userId,
      },
    );

    return BaseCollectionResponse.fromJson(response, (item) => PostModel.fromJson(item));
  }

  Future<BaseCollectionResponse<PostModel>> getPopularPostsList({required int pageNumber}) async {
    final response = await _apiManager.get(
      ApiConstants.apiPopularPosts,
      queryParameters: {
        ApiConstants.perPage: ApiConstants.defaultPageSize,
        ApiConstants.page: pageNumber,
      },
    );

    return BaseCollectionResponse.fromJson(response, (e) => PostModel.fromJson(e));
  }

  Future<BaseResponse<Map<String, dynamic>?>> likePost({required String postId}) async {
    final response = await _apiManager.post(ApiConstants.apiLikePost(postId));
    return BaseResponse.fromJson(response);
  }

  Future<BaseResponse<SuccessMessageModel>> savePost({required String postId, required String userId}) async {
    final response = await _apiManager.post(
      ApiConstants.apiSavePost(userId),
      data: {"post_id": postId},
    );
    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> blockUser({required int userId}) async {
    final response = await _apiManager.post(
      ApiConstants.apiBlockUser,
      data: {"blocked_user_id": userId},
    );
    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> deletePost({required int postId}) async {
    final response = await _apiManager.delete(ApiConstants.apiDeletePost(postId));
    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseResponse<SuccessMessageModel>> reportPost({required String postId, required String reasonId}) async {
    final response = await _apiManager.post(
      ApiConstants.apiReportPost,
      data: {"post_id": postId, "report_reason_id": reasonId},
    );
    return BaseResponse.fromJson(response, (data) => SuccessMessageModel.fromJson(data));
  }

  Future<BaseCollectionResponse<IntKeyStingValueModel?>> reportReasons({required String userId}) async {
    final response = await _apiManager.get(ApiConstants.apiReportReasons);
    return BaseCollectionResponse.fromJson(response, (item) => IntKeyStingValueModel.fromJson(item));
  }
}
