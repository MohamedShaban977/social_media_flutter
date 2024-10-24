import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/widgets/login_by_email_widget.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/widgets/login_by_phone_number_widget.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/widgets/login_with_social_media_widget.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/widgets/register_btn_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
      animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            /// welcome to hauui
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
              child: LabelScreenWidget(
                title: LocaleKeys.welcomeToHauui.tr(),
                subtitle: LocaleKeys.loginUsing.tr(),
              ),
            ),
            const SizedBox(height: AppDimens.widgetDimen24pt),

            CustomTabbedWidget(
              currentTabIndex: 0,
              tabController: _tabController,
              tabsLabels: [LocaleKeys.phoneNumber.tr(), LocaleKeys.email.tr()],
              physics: const NeverScrollableScrollPhysics(),
              spaceTapBarHeight: AppDimens.widgetDimen32pt,
              height: AppDimens.widgetDimen400pt,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                  child: LoginByPhoneNumberWidget(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                  child: LoginByEmailWidget(),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.widgetDimen24pt),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
              child: Row(
                children: [
                  const Expanded(
                      child: CustomDividerHorizontal(
                    indent: AppDimens.spacingSmall,
                    color: AppColors.grayishBlue,
                  )),
                  const SizedBox(width: AppDimens.spacingNormal),
                  Text(
                    LocaleKeys.orLoginWith.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyleManager.medium(
                      size: AppDimens.textSize14pt,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacingNormal),
                  const Expanded(
                      child: CustomDividerHorizontal(
                    endIndent: AppDimens.spacingSmall,
                    color: AppColors.grayishBlue,
                  )),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.widgetDimen24pt),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
              child: LoginWithSocialMediaWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RegisterBtnWidget(),
    );
  }
}
