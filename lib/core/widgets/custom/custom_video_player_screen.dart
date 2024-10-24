import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/enums/video_type.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_dailymotion_player.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:pod_player/pod_player.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class CustomVideoPlayerScreen extends StatefulWidget {
  const CustomVideoPlayerScreen({super.key, required this.media});

  final MediaModel media;

  @override
  State<CustomVideoPlayerScreen> createState() => _CustomVideoPlayerScreenState();
}

class _CustomVideoPlayerScreenState extends State<CustomVideoPlayerScreen> {
  late final PodPlayerController? _controller;

  @override
  void initState() {
    switch (widget.media.type) {
      case VideoType.youtube:
        _controller = PodPlayerController(
          playVideoFrom: PlayVideoFrom.youtube(widget.media.mediaLink ?? ""),
          podPlayerConfig: const PodPlayerConfig(autoPlay: false),
        )..initialise();
        break;
      case VideoType.mp4:
        if ((widget.media.mediaLink ?? "").contains(AppConstants.googleDrive)) {
          final fileId = (widget.media.mediaLink ?? "").split('/').reversed.skip(1).first;
          widget.media.mediaLink = AppConstants.googleDriveLink(fileId);
        }
        _controller = PodPlayerController(
            playVideoFrom: PlayVideoFrom.network(widget.media.mediaLink ?? ""),
            podPlayerConfig: const PodPlayerConfig(autoPlay: false))
          ..initialise();
        break;
      default:
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.media.type == VideoType.dailymotion
            ? CustomDailymotionPlayer(videoUrl: widget.media.mediaLink ?? "")
            : widget.media.type == VideoType.vimeo
                ? SizedBox(height: 250, child: VimeoPlayer(videoId: (widget.media.mediaLink ?? "").split('/').last))
                : _controller != null
                    ? PodVideoPlayer(
                        controller: _controller!,
                        matchVideoAspectRatioToFrame: true,
                        matchFrameAspectRatioToVideo: false)
                    : const CircularProgressIndicator(),
      ],
    );
  }
}
