import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/picker_type.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/camera_option_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'theme/text_style_manager.dart';

class FileManager {
  List<AssetEntity>? _selectedAssets;

  ThemeData get _pickerTheme {
    return ThemeData.light().copyWith(
      textTheme: TextTheme(
        bodyLarge: TextStyleManager.medium(
          color: AppColors.primary,
          size: AppDimens.textSize14pt,
        ),
        titleLarge: TextStyleManager.medium(
          color: AppColors.veryDarkGrayishBlue,
          size: AppDimens.textSize14pt,
        ),
        bodyMedium: TextStyleManager.medium(
          color: AppColors.veryDarkGrayishBlue,
          size: AppDimens.textSize14pt,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.veryDarkGrayishBlue,
      ),
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
        color: AppColors.veryDarkGrayishBlue,
      )),
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: AppColors.lightGrayishBlue4,
        onPrimary: AppColors.lightGrayishBlue4,
        secondary: AppColors.lightGrayishBlue4,
        onSecondary: AppColors.lightGrayishBlue4,
      ),
    );
  }

  Future<List<AssetEntity>?> pickAssets({
    required BuildContext context,
    List<AssetEntity>? selectedAssets,
    int maxAssets = 1,
    RequestType requestType = RequestType.all,
    int minimumRecordingDurationInSeconds = AppConstants.minimumRecordingDurationInSeconds,
    int maximumRecordingDurationInSeconds = AppConstants.maximumRecordingDurationInSeconds,
    Future<void> Function(List<AssetEntity>? assets, PickerType pickerType)? onAssetPicked,
  }) async {
    _selectedAssets = selectedAssets;

    try {
      final assetEntities = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          selectedAssets: selectedAssets,
          requestType: requestType,
          maxAssets: maxAssets,
          specialItemPosition: SpecialItemPosition.prepend,
          specialPickerType: SpecialPickerType.noPreview,
          specialItemBuilder: (_, path, length) => CameraOptionWidget(
            onOpenCameraTapped: () async => await _onOpenCameraTapped(
              context: context,
              requestType: requestType,
              maximumRecordingDurationInSeconds: maximumRecordingDurationInSeconds,
              minimumRecordingDurationInSeconds: minimumRecordingDurationInSeconds,
              onAssetPicked: onAssetPicked,
            ),
          ),
          pathNameBuilder: (path) => (path.isAll) ? LocaleKeys.allMedia.tr() : path.name,
          loadingIndicatorBuilder: (context, isAssetsEmpty) => const CustomProgressIndicator(),
          pickerTheme: _pickerTheme,
          textDelegate: Localizations.localeOf(context).languageCode == AppConstants.arLangCode
              ? const ArabicAssetPickerTextDelegate()
              : const EnglishAssetPickerTextDelegate(),
        ),
      );
      if (assetEntities != null) {
        _selectedAssets = assetEntities;
        onAssetPicked?.call(_selectedAssets, PickerType.gallery);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return _selectedAssets;
  }

  Future<void> _onOpenCameraTapped(
      {required BuildContext context,
      required RequestType requestType,
      required int minimumRecordingDurationInSeconds,
      required int maximumRecordingDurationInSeconds,
      required Future<void> Function(List<AssetEntity>? assets, PickerType pickerType)? onAssetPicked}) async {
    {
      final assetEntity = await _pickFromCamera(
        context: context,
        enableRecording: requestType.containsVideo(),
        minimumRecordingDuration: Duration(seconds: minimumRecordingDurationInSeconds),
        maximumRecordingDuration: Duration(seconds: maximumRecordingDurationInSeconds),
        onEntitySaving: onAssetPicked != null
            ? (context, viewType, file) async => _onEntitySaving(
                  context: context,
                  viewType: viewType,
                  file: file,
                  onAssetPicked: onAssetPicked,
                )
            : null,
      );

      if (context.mounted && assetEntity != null) {
        _updateSelectedAssets(context: context, assetEntity: assetEntity);
      }
    }
  }

  Future<AssetEntity?> _pickFromCamera({
    required BuildContext context,
    required EntitySaveCallback? onEntitySaving,
    required bool enableRecording,
    required Duration minimumRecordingDuration,
    Duration? maximumRecordingDuration,
  }) async {
    AssetEntity? assetEntity;

    try {
      assetEntity = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
          minimumRecordingDuration: minimumRecordingDuration,
          maximumRecordingDuration: maximumRecordingDuration,
          enableRecording: enableRecording,
          enableScaledPreview: false,
          resolutionPreset: ResolutionPreset.high,
          textDelegate: const EnglishCameraPickerTextDelegate(),
          theme: CameraPicker.themeData(AppColors.primary),
          onEntitySaving: onEntitySaving,
        ),
      );
    } catch (e) {
      logger.e(e.toString());
    }
    return assetEntity;
  }

  Future<dynamic> _onEntitySaving(
      {required BuildContext context,
      required CameraPickerViewType viewType,
      required File file,
      Future<void> Function(List<AssetEntity>? assets, PickerType pickerType)? onAssetPicked}) async {
    final assetEntity = await convertFileToAssetEntity(file, viewType);
    if (assetEntity != null) {
      _updateSelectedAssets(
        context: context,
        assetEntity: assetEntity,
      );
      onAssetPicked?.call([assetEntity], PickerType.camera);
    }
  }

  static Future<AssetEntity?> convertFileToAssetEntity(
    File file,
    CameraPickerViewType viewType,
  ) async {
    AssetEntity? assetEntity;

    if (viewType == CameraPickerViewType.image) {
      final appDir = await getTemporaryDirectory();
      final tempFilePath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(tempFilePath).writeAsBytes(file.readAsBytesSync());

      assetEntity = await PhotoManager.editor.saveImageWithPath(tempFilePath, title: '');
    }
    if (viewType == CameraPickerViewType.video) {
      assetEntity = await PhotoManager.editor.saveVideo(
        file,
        title: '${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
    }

    return assetEntity;
  }

  void _updateSelectedAssets({
    required BuildContext context,
    required AssetEntity assetEntity,
  }) {
    _selectedAssets = [assetEntity, ..._selectedAssets ?? []];
    Navigator.of(context).pop();
  }

  static String generateFileName({
    String? prefix,
    String? postfix,
  }) {
    return '${prefix ?? 'tmp_file'}_'
        '${postfix ?? DateTime.now().millisecondsSinceEpoch}';
  }

  static String getFileName(
    String filePath,
  ) =>
      filePath.substring(
        filePath.lastIndexOf('/') + 1,
      );

  static String getFileExtension(String fileName) => fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();

  static double getFileSizeInMB({
    required int lengthInBytes,
  }) =>
      double.tryParse((lengthInBytes / (1024 * 1024)).toStringAsFixed(3)) ?? 0;

  static Future<Uint8List> compressImage(Uint8List? imageData) async => await FlutterImageCompress.compressWithList(
        imageData!,
        format: CompressFormat.jpeg,
        quality: 100,
      );

  static Future<File> toFile(Uint8List imageData, String? name) async {
    final imageFile = await File('${(await getTemporaryDirectory()).path}/$name').create();
    imageFile.writeAsBytesSync(imageData);
    return imageFile;
  }
}
