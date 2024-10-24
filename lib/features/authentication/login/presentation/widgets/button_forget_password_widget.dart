import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ButtonForgetPasswordWidget extends StatelessWidget {
  const ButtonForgetPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Transform.translate(
        offset: const Offset(5.0, 0.0),
        child: TextButton(
          onPressed: () => Navigator.of(context).pushNamed(RoutesNames.forgetPasswordRoute),
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )),
          child: Text(
            LocaleKeys.didYouForgetPassword.tr(),
            textAlign: TextAlign.right,
            style: TextStyleManager.regular(
              size: AppDimens.textSize12pt,
              color: AppColors.veryDarkGrayishBlue,
            ),
          ),
        ),
      ),
    );
  }
}
