import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/user_existence_verification.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/phone_number_with_country_code_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/check_user_exists_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/screens/register_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PhoneOrEmailRegisterWidget extends ConsumerStatefulWidget {
  const PhoneOrEmailRegisterWidget(
      {super.key, required this.emailController, required this.phoneController, required this.countryCodeController});

  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;

  @override
  ConsumerState<PhoneOrEmailRegisterWidget> createState() => _PhoneOrEmailRegisterWidgetState();
}

class _PhoneOrEmailRegisterWidgetState extends ConsumerState<PhoneOrEmailRegisterWidget> with TickerProviderStateMixin {
  final _formKeyByPhone = GlobalKey<FormState>();
  final _formKeyByEmail = GlobalKey<FormState>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
      animationDuration: Duration.zero,
    )..addListener(_listenerTapController);
  }

  void _listenerTapController() {
    if (_tabController.index == 0) {
      ref.read(RegisterViewModel.verifyByProvider.notifier).update((state) => VerifyBy.sms);
    } else if (_tabController.index == 1) {
      ref.read(RegisterViewModel.verifyByProvider.notifier).update((state) => VerifyBy.email);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabbedWidget(
          tabController: _tabController,
          tabsLabels: [LocaleKeys.phoneNumber.tr(), LocaleKeys.email.tr()],
          currentTabIndex: 0,
          height: AppDimens.widgetDimen170pt,
          physics: const NeverScrollableScrollPhysics(),
          spaceTapBarHeight: AppDimens.widgetDimen45pt,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppDimens.spacingNormal,
              ),
              child: Form(
                key: _formKeyByPhone,
                onChanged: () => ref
                    .read(RegisterViewModel.disableButtonByPhoneProvider.notifier)
                    .update((state) => !_formKeyByPhone.currentState!.validate()),
                child: PhoneNumberWithCountryCodeWidget(
                  phoneNumberController: widget.phoneController,
                  countryCodeController: widget.countryCodeController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppDimens.spacingNormal,
              ),
              child: Form(
                key: _formKeyByEmail,
                onChanged: () => ref
                    .read(RegisterViewModel.disableButtonByEmailProvider.notifier)
                    .update((state) => !_formKeyByEmail.currentState!.validate()),
                child: TextFormFieldWithLabelWidget(
                  controller: widget.emailController,
                  label: LocaleKeys.email.tr(),
                  hintText: LocaleKeys.hintEmail.tr(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => ValidationUtil.isValidEmail(value!)?.empty(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.widgetDimen24pt),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.spacingNormal,
          ),
          child: Consumer(
            builder: (context, ref2, child) {
              final verifyBy = ref.watch(RegisterViewModel.verifyByProvider);
              final disableButtonByPhone = ref.watch(RegisterViewModel.disableButtonByPhoneProvider);
              final disableButtonByEmail = ref.watch(RegisterViewModel.disableButtonByEmailProvider);
              final disableButton = verifyBy == VerifyBy.sms
                  ? disableButtonByPhone
                  : verifyBy == VerifyBy.email
                      ? disableButtonByEmail
                      : true;
              return CustomButtonWithLoading(
                title: LocaleKeys.next.tr(),
                isDisabled: disableButton,
                onPressed: _onNextPressed,
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onNextPressed() async {
    await RegisterViewModel().checkIfUserExists(
      userExistenceVerification:
          _tabController.index == 0 ? UserExistenceVerification.phone : UserExistenceVerification.email,
      checkUserExistsRequestBody: CheckUserExistsRequestBody(
        countryCode: _tabController.index == 0 ? widget.countryCodeController.text : null,
        phoneNumber: _tabController.index == 0 ? widget.phoneController.text : null,
        email: _tabController.index == 1 ? widget.emailController.text : null,
      ),
      onSuccess: (message) => context.showToast(
        message: message,
      ),
      onFail: (errorMessage) async {
        if (errorMessage ==
            LocaleKeys.requestedInfoNotFound.tr(
              args: [
                LocaleKeys.notFound.tr(),
              ],
            )) {
          ref
              .read(
                RegisterViewModel.indexScreenProvider.notifier,
              )
              .update(
                (state) => state + 1,
              );
        } else {
          context.showToast(
            message: errorMessage,
          );
        }
      },
    );
  }
}
