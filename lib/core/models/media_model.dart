import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/enums/media_type.dart';
import 'package:hauui_flutter/core/constants/enums/video_type.dart';
import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaModel {
  int? id;
  late MediaType? mediaType;
  String? mediaLink;
  String? thumbnail;
  VideoType? type;

  MediaModel({
    this.id,
    this.mediaType = MediaType.image,
    this.mediaLink,
    this.thumbnail,
    this.type,
  });

  MediaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = JsonUtil.deserializeObject(
      json['media_type'],
      (element) => MediaTypeExtensions.tryParse(element, defaultValue: MediaType.image),
    );
    mediaLink = json['media_link'];
    type = mediaType == MediaType.video ? _getVideoType(json['media_link']) : null;
    thumbnail = mediaType == MediaType.video ? videoThumbnailUrl(json['media_link']) : json['media_link'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['media_type'] = mediaType?.name;
    map['media_link'] = mediaLink;
    map['thumbnail'] = thumbnail;
    return map..removeNullValues();
  }

  VideoType _getVideoType(String videoUrl) {
    if (VideoTypeExtension.isYoutube(videoUrl)) {
      return VideoType.youtube;
    } else if (VideoTypeExtension.isVimeo(videoUrl)) {
      return VideoType.vimeo;
    } else if (VideoTypeExtension.isDailymotion(videoUrl)) {
      return VideoType.dailymotion;
    } else {
      return VideoType.mp4;
    }
  }

  String videoThumbnailUrl(String videoUrl) {
    switch (type!) {
      case VideoType.youtube:
        return AppConstants.youtubeVideoThumbnailLink(
            videoUrl.contains('v=') ? videoUrl.split('v=').last : videoUrl.split('/').last);
      case VideoType.mp4:
        if (videoUrl.contains(AppConstants.googleDrive)) {
          return AppConstants.googleDriveVideoThumbnailLink(mediaLink!.split('id=').last);
        } else {
          ///  return the link for now and we will change it later as it will need async method.
          return mediaLink ?? "";
        }
      case VideoType.dailymotion:
        return AppConstants.dailymotionLink(mediaLink!.split('/').last);
      case VideoType.vimeo:

        ///  return the link for now and we will change it later as it will need async method.
        return mediaLink ?? "";
    }
  }

  Future<void> get mp4ThumbnailPath async => await VideoThumbnail.thumbnailFile(
        video: mediaLink ?? "",
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
      ).then((value) => thumbnail = value ?? "");
}
