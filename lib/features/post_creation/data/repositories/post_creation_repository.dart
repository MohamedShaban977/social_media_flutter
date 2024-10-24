import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/post_creation/data/services/post_creation_service.dart';

class PostCreationRepository {
  final PostCreationService _postCreationService;

  PostCreationRepository(this._postCreationService);

  Future<Either<Failure, BaseCollectionResponse<HashtagModel>>> getSuggestedHashtags({
    required int pageNumber,
    required String keyWord,
  }) async {
    try {
      final response = await _postCreationService.getSuggestedHashtags(
        pageNumber: pageNumber,
        keyWord: keyWord,
      );
      return (response.success && response.data != null)
          ? Right(
              response,
            )
          : left(
              ServerFailure(
                response.message,
              ),
            );
    } on ServerException catch (error) {
      return left(
        ServerFailure(
          error.message,
        ),
      );
    }
  }
}
