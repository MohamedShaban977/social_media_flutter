import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/verification_type.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/bool_extensions.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/firebase_manager.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/device_model.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/register_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/screens/register_view_model.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/widgets/name_register_widget.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/widgets/password_register_widget.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/widgets/phone_or_email_register_widget.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/screens/verification_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryCodeController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final indexScreen = ref.watch(RegisterViewModel.indexScreenProvider);
        return PopScope(
          canPop: indexScreen == 0,
          onPopInvoked: (value) => _onPopInvoked(value, ref),
          child: Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.createNewAccount.tr()),
              leading: InkWell(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.widgetDimen45pt),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                    child: LabelScreenWidget(
                      title: LocaleKeys.register.tr(),
                      subtitle: LocaleKeys.enterFollowingDetails.tr(),
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen24pt),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                    child: LinearProgressIndicator(
                      value: indexScreen / AppConstants.registerSteps,
                      minHeight: AppDimens.widgetDimen8pt,
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius8pt),
                      color: AppColors.vividCyan,
                      backgroundColor: AppColors.lightGrayishBlue2,
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        LocaleKeys.registerSteps.tr(args: [
                          (indexScreen + 1).toString(),
                          AppConstants.registerSteps.toString(),
                        ]),
                        style: TextStyleManager.regular(
                          color: AppColors.veryDarkGrayishBlue,
                          size: AppDimens.textSize12pt,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen24pt),
                  if (indexScreen == 0) NameRegisterWidget(nameController: nameController),
                  if (indexScreen == 1)
                    PhoneOrEmailRegisterWidget(
                      phoneController: phoneController,
                      countryCodeController: countryCodeController,
                      emailController: emailController,
                    ),
                  if (indexScreen == 2)
                    PasswordRegisterWidget(
                      passwordController: passwordController,
                      onRegisterPressed: () => _onRegisterPressed(ref),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRegisterPressed(WidgetRef ref) async {
    final String? fcmToken = await FirebaseManager.getFcmToken();
    await ref.read(RegisterViewModel.registerProvider.notifier).register(
          RegisterRequestBody(
            phoneNumber: phoneController.text,
            countryCode: countryCodeController.text,
            email: emailController.text,
            name: nameController.text,
            password: passwordController.text,
            verifyBy: ref.read(RegisterViewModel.verifyByProvider).name,
            device: DeviceModel(token: fcmToken.orEmpty()),
          ),
        );
    final registerState = ref.read(RegisterViewModel.registerProvider);

    if (registerState.hasValue) {
      if (registerState.value != null) {
        if (registerState.value!.data != null && registerState.value!.data!.verified.orFalse()) {
          Navigator.pushReplacementNamed(navigatorKey.currentContext!, RoutesNames.mainLayoutRoute);
        } else {
          final verifyBy = ref.read(RegisterViewModel.verifyByProvider);
          VerificationViewModel.navigateToVerificationScreen(
            VerificationRouteModel(
              verifyBy: verifyBy,
              userId: registerState.value!.data!.id,
              navigationFromWhere: VerificationType.register,
              senderData: verifyBy == VerifyBy.email
                  ? emailController.text
                  : verifyBy == VerifyBy.sms
                      ? '${countryCodeController.text} ${phoneController.text}'
                      : '-',
              title: LocaleKeys.createNewAccount.tr(),
              verificationCode: registerState.value?.data?.verificationCode,
            ),
          );
        }
      }
    }
    if (registerState.hasError) {
      navigatorKey.currentContext!.showToast(message: registerState.error.toString());
    }
  }

  void _onPopInvoked(didPop, WidgetRef ref) {
    if (!didPop) {
      int currentIndex = ref.read(RegisterViewModel.indexScreenProvider.notifier).update((state) => state - 1);
      switch (currentIndex) {
        case 0:
          ref.invalidate(
            RegisterViewModel.disableButtonByPhoneProvider,
          );
          ref.invalidate(
            RegisterViewModel.disableButtonByEmailProvider,
          );
        case 1:
          ref.invalidate(
            RegisterViewModel.disableButtonByPasswordProvider,
          );
      }
      return;
    }
    ref.invalidate(
      RegisterViewModel.disableButtonByNameProvider,
    );
  }
}
