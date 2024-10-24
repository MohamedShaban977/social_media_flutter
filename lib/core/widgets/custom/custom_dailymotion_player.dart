import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';

class CustomDailymotionPlayer extends StatelessWidget {
  const CustomDailymotionPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(AppConstants.dailyMotionHTMLString(videoUrl.split('/').last));
  }
}
