import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_fonts.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/screens/login_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _navigateToDestination);
      },
    );
  }

  void _navigateToDestination() {
    final String? token = SharedPreferencesManager.getData(key: AppConstants.prefKeyAccessToken);
    if (token != null) {
      if (UserExtensions.getCachedUser()?.verified ?? false) {
        Navigator.pushReplacementNamed(context, RoutesNames.mainLayoutRoute);
        ref.read(AccountViewModel.accountModeProvider.notifier).update((state) => state = AccountMode.authorized);
      } else {
        LoginViewModel.navigateToLoginScreen();
      }
    } else {
      LoginViewModel.navigateToLoginScreen();
    }
    logger.i(ref.read(AccountViewModel.accountModeProvider));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const CustomImage.svg(src: AppSvg.icLogoHauui),
            const SizedBox(height: AppDimens.widgetDimen16pt),
            Text(
              LocaleKeys.appName.tr(),
              style: TextStyleManager.bold(
                color: AppColors.veryDarkGrayishBlue,
                size: AppDimens.textSize42pt,
              ).copyWith(
                fontFamily: AppFonts.montserratFontFamily,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.developedBy.tr(),
                  style: TextStyleManager.medium(
                    color: AppColors.veryDarkGrayishBlue,
                    size: AppDimens.textSize14pt,
                  ).copyWith(
                    fontFamily: AppFonts.montserratFontFamily,
                  ),
                ),
                const SizedBox(width: 3.0),
                const CustomImage.asset(
                  src: AppPng.icLogoInova,
                  height: AppDimens.spacingNormal,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingNormal),
          ],
        ),
      ),
    );
  }
}
