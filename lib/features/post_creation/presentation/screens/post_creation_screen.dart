import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/permission_type.dart';
import 'package:hauui_flutter/core/constants/enums/snackbar_message_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/permissions_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/add_hobby_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/add_post_title_and_description_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/choose_post_level_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/input_hashtags_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/list_video_links.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/post_media_options_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PostCreationScreen extends ConsumerStatefulWidget {
  const PostCreationScreen.create({super.key});

  const PostCreationScreen.edit({super.key});

  @override
  ConsumerState<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends ConsumerState<PostCreationScreen> with WidgetsBindingObserver {
  bool _shouldRecallGetCurrentLocation = false;
  late final _locationUtil = const LocationUtil();
  StreamSubscription<ServiceStatus>? _locationServiceStatusStreamSubscription;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _isLevelSelected = ValueNotifier<bool?>(
    null,
  );
  final _isHobbySelected = ValueNotifier<bool?>(
    null,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getCurrentLocation();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRecallGetCurrentLocation) {
      _shouldRecallGetCurrentLocation = false;
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_locationServiceStatusStreamSubscription != null) {
      LocationUtil.cancelLocationServiceListener(
        locationServiceStatusStreamSubscription: _locationServiceStatusStreamSubscription!,
        onError: (error) => context.showToast(
          message: error.toString(),
        ),
      );
    }
    _titleController.dispose();
    _descriptionController.dispose();
    _isLevelSelected.dispose();
    _isHobbySelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: _onCloseTapped,
          child: const Icon(
            Icons.close,
          ),
        ),
        title: Text(
          LocaleKeys.newPost.tr(),
          style: TextStyleManager.semiBold(
            size: AppDimens.textSize18pt,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: AppDimens.spacingNormal,
            ),
            child: InkWell(
              onTap: _onPreviewTapped,
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppDimens.spacingSmall,
                  vertical: AppDimens.customSpacing4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGrayishBlue4,
                  borderRadius: BorderRadius.circular(
                    AppDimens.cornerRadius3pt,
                  ),
                ),
                child: Text(
                  LocaleKeys.preview.tr(),
                  style: TextStyleManager.regular(
                    size: AppDimens.textSize14pt,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          )
        ],
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(
            AppDimens.zero,
          ),
          child: CustomDividerHorizontal(
            thickness: AppDimens.dividerThickness0Point5pt,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: AppDimens.spacingNormal,
        ),
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimens.spacingNormal,
                    end: AppDimens.spacingNormal,
                    bottom: AppDimens.spacingSmall,
                  ),
                  child: AddPostTitleAndDescriptionWidget(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                  ),
                  child: InputHashtagsWidget(),
                ),
                const SliverPadding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                    vertical: AppDimens.spacingNormal,
                  ),
                  sliver: ListVideoLinks(),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: AppDimens.spacingNormal,
                  ),
                  child: CustomDividerHorizontal(),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                  ),
                  child: PostMediaOptionsWidget(),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: AppDimens.spacingNormal,
                  ),
                  child: CustomDividerHorizontal(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                  ),
                  child: AddHobbyWidget(
                    isHobbySelected: _isHobbySelected,
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: AppDimens.spacingNormal,
                  ),
                  child: CustomDividerHorizontal(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingNormal,
                  ),
                  child: ChoosePostLevelWidget(
                    isLevelSelected: _isLevelSelected,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCloseTapped() {
    //todo Implement close
  }

  void _onPreviewTapped() {
    if (_isInputValid()) {
      context.showToast(
        message: 'Navigate to \'Preview\' route',
      );
    }
  }

  bool _isInputValid() => _isBasicInputValid() & _isHobbyValid() & _isLevelValid();

  bool _isBasicInputValid() {
    if (_titleController.text.isEmpty &&
        _descriptionController.text.isEmpty &&
        ref.read(PostCreationViewModel.videoLinksProvider).isEmpty) {
      context.showCustomSnackBar(
        messageType: SnackBarMessageType.info,
        text: LocaleKeys.youCannotCreatePostWithoutAddTitleOrDescriptionOrMedia.tr(),
        showOnTop: true,
      );
      return false;
    }
    return true;
  }

  bool _isHobbyValid() {
    final isHobbySelected = ref.read(PostCreationViewModel.selectedHobbiesProvider).isNotEmpty;
    _isHobbySelected.value = isHobbySelected;
    return isHobbySelected;
  }

  bool _isLevelValid() {
    final isLevelSelected = ref.read(PostCreationViewModel.selectedLevelIdProvider) != null;
    _isLevelSelected.value = isLevelSelected;
    return isLevelSelected;
  }

  Future<void> _getCurrentLocation() async {
    await _locationUtil.getCurrentLocation(
      onLocationGranted: (latLng) => _onLocationGranted(
        latLng: latLng,
      ),
      onLocationDeniedForever: _onLocationDeniedForever,
      onLocationServiceDisabled: _onLocationServiceDisabled,
    );
  }

  //TODO After completing this method, Check if you still keep it here or it is recommented to move it to viewmodel
  void _onLocationGranted({
    required LatLng latLng,
  }) {
    final lat = ref.read(PostCreationViewModel.latProvider.notifier).update(
          (state) => state = latLng.latitude,
        );
    final lng = ref.read(PostCreationViewModel.lngProvider.notifier).update(
          (state) => state = latLng.longitude,
        );
    logger.i(
      'Location is granted: $lat, $lng',
    );
    context.showToast(
      message: 'Location is granted: $lat, $lng',
    );
  }

  Future<void> _onLocationDeniedForever() async {
    context
        .showBottomSheet(
      widget: PermissionsBottomSheet(
        requiredPermissions: const [
          PermissionType.location,
        ],
      ),
    )
        .then(
      (isAppSettingsScreenOpened) {
        if (isAppSettingsScreenOpened != null) {
          _shouldRecallGetCurrentLocation = isAppSettingsScreenOpened;
        }
      },
    );
  }

  void _onLocationServiceDisabled() {
    context.showAdaptiveDialog(
      title: LocaleKeys.forBetterExperienceTurnOnDeviceLocation.tr(),
      negativeBtnName: LocaleKeys.noThanks.tr(),
      positiveBtnName: LocaleKeys.openSettings.tr(),
      positiveBtnAction: () async {
        await _openSettingsPressed();
      },
    );
  }

  Future<void> _openSettingsPressed() async {
    _locationServiceStatusStreamSubscription = await _locationUtil.openLocationSettings(
      onAndroidLocationServiceEnabled: (latLng) => _onLocationGranted(
        latLng: latLng,
      ),
      onIOSLocationServiceEnabled: () async {
        await _getCurrentLocation();
      },
    );
  }
}
