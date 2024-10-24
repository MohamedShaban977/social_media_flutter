import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/posts/data/services/vimeo_service.dart';

class VimeoRepository {
  final VimeoService _vimeoService;

  VimeoRepository(this._vimeoService);

  Future<Either<Failure, BaseResponse<Map<String, dynamic>>>> getVimeoThumbnail({required String videoId}) async {
    try {
      final res = await _vimeoService.getVimeoThumbnail(videoId: videoId);
      return res.success ? Right(res) : left(ServerFailure(res.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
