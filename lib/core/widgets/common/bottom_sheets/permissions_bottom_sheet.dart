import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/permission_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/cell_permission.dart';
import 'package:hauui_flutter/core/models/permission_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PermissionsBottomSheet extends StatelessWidget {
  final List<PermissionType> requiredPermissions;

  late final permissions = [
    if (requiredPermissions.contains(PermissionType.camera))
      const PermissionModel(
        icon: AppSvg.icCameraRoundedGrey,
        permission: LocaleKeys.camera,
        description: LocaleKeys.recordYourShow,
      ),
    if (requiredPermissions.contains(PermissionType.microphone))
      const PermissionModel(
        icon: AppSvg.icMicRoundedGrey,
        permission: LocaleKeys.microphone,
        description: LocaleKeys.accessYourMicrophone,
      ),
    if (requiredPermissions.contains(PermissionType.location))
      const PermissionModel(
        icon: AppSvg.icLocationRoundedGrey,
        permission: LocaleKeys.location,
        description: LocaleKeys.toShowYourVideoInHauuiMap,
      ),
    if (requiredPermissions.contains(PermissionType.storage))
      const PermissionModel(
        icon: AppSvg.icFilesRoundedGrey,
        permission: LocaleKeys.storage,
        description: LocaleKeys.allowYouUploadPhotosAndVideosFormYourDevice,
      ),
  ];

  late final locationUtil = const LocationUtil();

  PermissionsBottomSheet({
    super.key,
    required this.requiredPermissions,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) => SizedBox(
        height: context.height * 0.95,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppDimens.cornerRadius16pt,
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () => _onCloseTapped(
                  context: context,
                ),
                child: const Icon(
                  Icons.close,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimens.spacingNormal,
                    top: AppDimens.spacingNormal,
                    end: AppDimens.customSpacing20,
                    bottom: AppDimens.customSpacing44,
                  ),
                  child: Text(
                    LocaleKeys.pleaseAllowPermissions.tr(),
                    style: TextStyleManager.bold(
                      size: AppDimens.textSize24pt,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.customSpacing20,
                    ),
                    children: permissions
                        .map(
                          (permission) => CellPermission(
                            permission: permission,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                    vertical: AppDimens.spacingLarge,
                  ),
                  child: ElevatedButton(
                    onPressed: () async => await _onOkPressed(
                      context: context,
                    ),
                    child: Text(
                      LocaleKeys.okLetUsDoIt.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCloseTapped({
    required BuildContext context,
  }) =>
      Navigator.pop(context);

  Future<void> _onOkPressed({
    required BuildContext context,
  }) async {
    await locationUtil.openAppSettings().then(
          (isOpened) => Navigator.pop(
            context,
            isOpened,
          ),
        );
  }
}
