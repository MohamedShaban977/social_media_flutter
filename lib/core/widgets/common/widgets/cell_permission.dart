import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/models/permission_model.dart';

class CellPermission extends StatelessWidget {
  final PermissionModel permission;

  const CellPermission({
    super.key,
    required this.permission,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: AppDimens.spacing5XLarge,
      ),
      child: Row(
        children: [
          CustomImage.svg(
            src: permission.icon,
          ),
          const SizedBox(
            width: AppDimens.widgetDimen8pt,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission.permission.tr(),
                  style: TextStyleManager.semiBold(
                    size: AppDimens.textSize18pt,
                  ),
                ),
                Text(
                  permission.description.tr(),
                  style: TextStyleManager.regular(
                    color: AppColors.darkGrayishBlue,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
