import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PhoneNumberWithCountryCodeWidget extends StatefulWidget {
  const PhoneNumberWithCountryCodeWidget({
    super.key,
    this.radius = 8.0,
    required this.phoneNumberController,
    required this.countryCodeController,
  });

  final double radius;
  final TextEditingController phoneNumberController;
  final TextEditingController countryCodeController;

  @override
  State<PhoneNumberWithCountryCodeWidget> createState() => _PhoneNumberWithCountryCodeWidgetState();
}

class _PhoneNumberWithCountryCodeWidgetState extends State<PhoneNumberWithCountryCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppDimens.customSpacing4),
          child: Text(
            LocaleKeys.phoneNumber.tr(),
            style: TextStyleManager.regular(
              color: AppColors.black,
              size: AppDimens.textSize12pt,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        Row(
          children: [
            SizedBox(
              width: context.width * 0.22,
              child: TextFormField(
                readOnly: true,
                onTap: () => context.presentCountryPicker(widget.countryCodeController),
                controller: widget.countryCodeController,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (value) => ValidationUtil.isValidInputField(value).empty(),
                decoration: InputDecoration(
                  hintText: LocaleKeys.hintCountryCode.tr(),
                  prefixIcon: const SizedBox.shrink(),
                  prefixIconConstraints: const BoxConstraints(minWidth: AppDimens.widgetDimen16pt),
                  suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                  suffixIconConstraints: const BoxConstraints(minWidth: AppDimens.widgetDimen32pt),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.widgetDimen16pt),

            /// Phone number input
            Expanded(
              child: TextFormField(
                controller: widget.phoneNumberController,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                validator: (value) => ValidationUtil.isValidPhoneNumber(value).empty(),
                decoration: InputDecoration(
                  hintText: LocaleKeys.hintPhoneNumber.tr(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
