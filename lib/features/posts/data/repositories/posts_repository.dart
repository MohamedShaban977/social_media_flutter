import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/data/services/posts_service.dart';

class PostsRepository {
  final PostsService _postsService;

  PostsRepository(this._postsService);

  Future<Either<Failure, BaseCollectionResponse<PostModel>>> getPostsList({
    required int pageNumber,
    int? eventId,
    int? hobbyId,
    int? userId,
  }) async {
    try {
      final res = await _postsService.getPostsList(
        pageNumber: pageNumber,
        eventId: eventId,
        hobbyId: hobbyId,
        userId: userId,
      );
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseCollectionResponse<PostModel>>> getPopularPostsList({required int pageNumber}) async {
    try {
      final res = await _postsService.getPopularPostsList(pageNumber: pageNumber);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<Map<String, dynamic>?>>> likePost({required String postId}) async {
    try {
      final res = await _postsService.likePost(postId: postId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> savePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final res = await _postsService.savePost(postId: postId, userId: userId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> blockUser({
    required int userId,
  }) async {
    try {
      final res = await _postsService.blockUser(userId: userId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> deletePost({required int postId}) async {
    try {
      final res = await _postsService.deletePost(postId: postId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
