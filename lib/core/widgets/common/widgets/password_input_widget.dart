import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'validation_with_visibility_input_widget.dart';

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({
    super.key,
    required this.passwordController,
    required this.label,
    required this.isVisiblePassword,
    this.showValidation = false,
    this.hintText,
  });

  final TextEditingController passwordController;
  final String label;
  final String? hintText;
  final bool showValidation;

  final ValueNotifier<bool> isVisiblePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          builder: (context, isVisible, child) {
            return TextFormFieldWithLabelWidget(
              controller: passwordController,
              label: label,
              hintText: hintText ?? LocaleKeys.hintPassword.tr(),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: isVisible,
              validator: (value) => showValidation
                  ? ValidationUtil.isValidPasswordWithValidation(value!).empty()
                  : ValidationUtil.isValidPassword(value!).empty(),
              suffixIcon: InkWell(
                onTap: () => isVisiblePassword.value = !isVisible,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppDimens.spacingSmall),
                  child: CustomImage.svg(
                    src: isVisible ? AppSvg.icEyeOff : AppSvg.icEye,
                  ),
                ),
              ),
            );
          },
          valueListenable: isVisiblePassword,
        ),
        if (showValidation)
          ValidationWithVisibilityInputWidget(
            controller: passwordController,
          ),
      ],
    );
  }
}
