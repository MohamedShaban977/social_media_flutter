import 'package:flutter/cupertino.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class CounterWidget extends StatelessWidget {
  final String count;
  final String title;

  const CounterWidget({
    super.key,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            bottom: AppDimens.spacingSmall,
          ),
          child: Text(
            count,
            style: TextStyleManager.medium(),
          ),
        ),
        Text(
          title,
          style: TextStyleManager.medium(
            size: AppDimens.textSize12pt,
            color: AppColors.veryDarkBlue.withOpacity(
              0.3,
            ),
          ),
        ),
      ],
    );
  }
}
