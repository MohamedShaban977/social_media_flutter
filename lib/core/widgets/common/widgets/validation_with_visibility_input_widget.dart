import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/regex_util.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ValidationWithVisibilityInputWidget extends StatefulWidget {
  const ValidationWithVisibilityInputWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ValidationWithVisibilityInputWidget> createState() => _ValidationWithVisibilityInputWidgetState();
}

class _ValidationWithVisibilityInputWidgetState extends State<ValidationWithVisibilityInputWidget> {
  final _isPasswordEightCharacters = ValueNotifier<bool>(false);
  final _hasPasswordLettersAndNumber = ValueNotifier<bool>(false);

  void onPasswordChanged() {
    _isPasswordEightCharacters.value = false;
    if (widget.controller.text.length >= 8 && widget.controller.text.length <= 20) {
      _isPasswordEightCharacters.value = true;
    }

    _hasPasswordLettersAndNumber.value = false;
    if (RegexUtil.rxPassword.hasMatch(widget.controller.text)) {
      _hasPasswordLettersAndNumber.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimens.widgetDimen8pt),
        Text(
          LocaleKeys.yourPasswordMustHave.tr(),
          style: TextStyleManager.regular(
            color: AppColors.veryDarkDesaturatedBlue,
            size: AppDimens.textSize12pt,
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        ValueListenableBuilder(
          builder: (context, isValid, child) => _ItemValidationWidget(
            title: LocaleKeys.passwordValidEightCharacters.tr(),
            isValid: isValid,
          ),
          valueListenable: _isPasswordEightCharacters,
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        ValueListenableBuilder(
          builder: (context, isValid, child) => _ItemValidationWidget(
            title: LocaleKeys.passwordValidLettersNumber.tr(),
            isValid: isValid,
          ),
          valueListenable: _hasPasswordLettersAndNumber,
        ),
      ],
    );
  }
}

class _ItemValidationWidget extends StatelessWidget {
  const _ItemValidationWidget({
    required this.isValid,
    required this.title,
  });

  final bool isValid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: AppDimens.widgetDimen24pt,
          height: AppDimens.widgetDimen24pt,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: isValid
                  ? Border.all(color: AppColors.vividCyan, width: AppDimens.borderWidth2pt)
                  : Border.all(color: Colors.grey.shade400, width: AppDimens.borderWidth2pt),
              borderRadius: BorderRadius.circular(AppDimens.cornerRadius16pt)),
          child: Center(
            child: Icon(
              Icons.check,
              color: isValid ? AppColors.vividCyan : Colors.grey.shade400,
              size: AppDimens.widgetDimen16pt,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.widgetDimen8pt),
        Text(
          title,
          style: TextStyleManager.regular(
            color: AppColors.darkGrayishBlue3,
            size: AppDimens.textSize12pt,
          ),
        )
      ],
    );
  }
}
