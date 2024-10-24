import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/utils/url_util.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_check_box_form_field.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_check_box_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyCheckWidget extends StatelessWidget {
  const PrivacyPolicyCheckWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCheckboxFormField(
      validator: (value) => ValidationUtil.isValidAgreeToTerms(value)?.empty(),
      showErrorMessage: false,
      title: Expanded(
        child: Text.rich(
          style: TextStyleManager.regular(
            color: AppColors.veryDarkGrayishBlue3,
            size: AppDimens.textSize12pt,
          ),
          TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.privacyPoliceAgreement.tr(),
              ),
              TextSpan(
                text: LocaleKeys.termsOfUse.tr(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => UrlUtil.launchURL(
                        url: ApiConstants.termsOfUseUrl,
                        mode: LaunchMode.externalApplication,
                      ),
              ),
              TextSpan(
                text: LocaleKeys.andWithSpacesBeforeAndAfter.tr(),
              ),
              TextSpan(
                text: LocaleKeys.privacyPolicy.tr(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => UrlUtil.launchURL(
                        url: ApiConstants.privacyPolicyUrl,
                        mode: LaunchMode.externalApplication,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
