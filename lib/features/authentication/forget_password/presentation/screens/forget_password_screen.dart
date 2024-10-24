import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/widgets/forget_password_by_email_widget.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/widgets/forget_password_by_phone_number_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final _currentTabIndex = ValueNotifier<int>(
    0,
  );

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
      animationDuration: Duration.zero,
    )..addListener(
        () {
          _currentTabIndex.value = _tabController.index;
        },
      );
    ;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _currentTabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(height: context.height * 0.1),
          Padding(
            padding: const EdgeInsets.all(AppDimens.spacingNormal),
            child: ValueListenableBuilder(
              builder: (context, currentTabIndex, child) {
                return LabelScreenWidget(
                  title: LocaleKeys.forgetPassword.tr(),
                  subtitle: currentTabIndex == 0
                      ? LocaleKeys.enterPhoneNumberToReceiveVerificationCodeOnIt.tr()
                      : LocaleKeys.enterEmailToReceiveVerificationCodeOnIt.tr(),
                );
              },
              valueListenable: _currentTabIndex,
            ),
          ),
          const SizedBox(height: AppDimens.widgetDimen32pt),
          CustomTabbedWidget(
            currentTabIndex: 0,
            tabController: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            height: context.height * 0.5,
            spaceTapBarHeight: AppDimens.widgetDimen32pt,
            tabsLabels: [
              LocaleKeys.phoneNumber.tr(),
              LocaleKeys.email.tr(),
            ],
            children: const [
              ForgetPasswordByPhoneNumberWidget(),
              ForgetPasswordByEmailWidget(),
            ],
          ),
          const SizedBox(height: AppDimens.widgetDimen24pt),
        ],
      ),
    );
  }
}
