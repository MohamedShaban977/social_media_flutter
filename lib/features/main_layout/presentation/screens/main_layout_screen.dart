import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/alert_dialog_type.dart';
import 'package:hauui_flutter/core/constants/enums/bottom_tab_bar_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/app_util.dart';
import 'package:hauui_flutter/core/utils/url_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/chat/presentation/screens/chat_screen.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_screen.dart';
import 'package:hauui_flutter/features/main_activity_creation/presentation/bottom_sheets/creation_bottom_sheet.dart';
import 'package:hauui_flutter/features/main_layout/presentation/screens/main_layout_view_model.dart';
import 'package:hauui_flutter/features/map/presentation/screens/map_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/levels_screen.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_screen.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class MainLayoutScreen extends ConsumerStatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  ConsumerState<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends ConsumerState<MainLayoutScreen> with WidgetsBindingObserver {
  final _children = [
    const PostsScreen(),
    const EventsScreen(),
    CreationBottomSheet(),
    const ChatScreen(),
    const MapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (SharedPreferencesManager.getData(key: AppConstants.prefKeyCanCheckUpdate) == null) {
        _canCheckUpdate(false);
      }
      await ref.read(MainLayoutViewModel.checkUpdateVersionProvider.notifier).checkUpdateVersion();
      _handleShowDialogUpdateVersion();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleShowDialogUpdateVersion();
    }
  }

  Future<void> _handleShowDialogUpdateVersion() async {
    final checkUpdateVersionStatus = ref.read(MainLayoutViewModel.checkUpdateVersionProvider);
    final buildNumber = double.tryParse((await AppUtil.getAppInfo()).buildNumber);
    final bool canCheck = SharedPreferencesManager.getData(key: AppConstants.prefKeyCanCheckUpdate);

    if (checkUpdateVersionStatus.hasValue && checkUpdateVersionStatus.value != null) {
      if ((checkUpdateVersionStatus.value?.shouldForceUpdate ?? false) &&
          buildNumber != checkUpdateVersionStatus.value?.latestBuildNumber) {
        _showDialogForceUpdate();
      } else if (!(checkUpdateVersionStatus.value?.shouldForceUpdate ?? false) &&
          buildNumber != checkUpdateVersionStatus.value?.latestBuildNumber &&
          !canCheck) {
        _showDialogNormalUpdate(
          checkUpdateVersionStatus.value?.latestBuildNumber,
        );
      }
    }
    if (checkUpdateVersionStatus.hasError) {
      context.showToast(message: checkUpdateVersionStatus.error.toString());
    }
  }

  Future<void> _showDialogForceUpdate() {
    return context.showCustomDialog(
      alertDialogType: AlertDialogType.constructive,
      icon: AppSvg.icUpdateVersion,
      title: LocaleKeys.newForceUpdateTitle.tr(),
      content: LocaleKeys.newForceUpdateSubtitle.tr(),
      positiveBtnName: LocaleKeys.updateNow.tr(),
      positiveBtnAction: () => _goToUpdateFromStore(),
    );
  }

  Future<void> _showDialogNormalUpdate(double? latestBuildNumber) {
    return context
        .showCustomDialog(
          alertDialogType: AlertDialogType.constructive,
          icon: AppSvg.icUpdateVersion,
          title: LocaleKeys.newUpdateTitle.tr(),
          content: LocaleKeys.newUpdateSubtitle.tr(),
          positiveBtnName: LocaleKeys.updateNow.tr(),
          cancelable: true,
          negativeBtnName: LocaleKeys.cancel.tr(),
          negativeBtnAction: () => _canCheckUpdate(true),
          positiveBtnAction: () => _goToUpdateFromStore(),
        )
        .whenComplete(() => _canCheckUpdate(true));
  }

  Future<void> _goToUpdateFromStore() async {
    final packageName = (await AppUtil.getAppInfo()).packageName;
    if (Platform.isAndroid || Platform.isIOS) {
      final url = Platform.isAndroid ? AppConstants.playStore(packageName) : AppConstants.appStore;
      UrlUtil.launchURL(
        url: url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<bool> _canCheckUpdate(bool canCheckUpdate) async {
    return await SharedPreferencesManager.saveData(
      key: AppConstants.prefKeyCanCheckUpdate,
      value: canCheckUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(MainLayoutViewModel.bottomTabsIndex);
    return Scaffold(
      body: _children[selectedIndex],
      endDrawer: const LevelsScreen.edit(
        openWithDrawer: true,
      ),
      endDrawerEnableOpenDragGesture: false,
      bottomNavigationBar: SizedBox(
        height: AppDimens.tabBarHeight84pt,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.vividPink,
          unselectedItemColor: AppColors.veryDarkGrayishBlue,
          selectedLabelStyle: TextStyleManager.medium(size: AppDimens.textSize10pt),
          unselectedLabelStyle: TextStyleManager.regular(size: AppDimens.textSize10pt),
          elevation: 0.1,
          onTap: (index) => _onBottomNavigationBarTapped(index),
          items: [
            BottomNavigationBarItem(
              label: LocaleKeys.home.tr(),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.customSpacing4),
                child: CustomImage.svg(
                  src: selectedIndex == 0 ? AppSvg.icSelectedHome : AppSvg.icHome,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: LocaleKeys.event.tr(),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.customSpacing4),
                child: CustomImage.svg(
                  src: selectedIndex == 1 ? AppSvg.icSelectedCalendar : AppSvg.icCalendar,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: LocaleKeys.create.tr(),
              icon: const Padding(
                padding: EdgeInsets.only(bottom: AppDimens.customSpacing4),
                child: CustomImage.svg(
                  src: AppSvg.icAdd,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: LocaleKeys.chat.tr(),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.customSpacing4),
                child: CustomImage.svg(
                  src: selectedIndex == 3 ? AppSvg.icSelectedChat : AppSvg.icChat,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: LocaleKeys.map.tr(),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.customSpacing4),
                child: CustomImage.svg(
                  src: selectedIndex == 4 ? AppSvg.icSelectedLocation : AppSvg.icMap,
                  height: AppDimens.widgetDimen24pt,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavigationBarTapped(int index) {
    if (index == BottomTabBarType.create.index) {
      ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized
          ? context.showBottomSheet(widget: _children[BottomTabBarType.create.index])
          : context.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    } else if (index == BottomTabBarType.chat.index) {
      ref.read(AccountViewModel.accountModeProvider) == AccountMode.authorized
          ? ref.read(MainLayoutViewModel.bottomTabsIndex.notifier).setIndex(BottomTabBarType.chat.index)
          : context.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    } else {
      ref.read(MainLayoutViewModel.bottomTabsIndex.notifier).setIndex(index);
    }
  }
}
