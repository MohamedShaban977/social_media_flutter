import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_form_field.dart';

class TextFormFieldWithLabelWidget extends StatelessWidget {
  const TextFormFieldWithLabelWidget({
    super.key,
    required this.label,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.onTap,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSaved,
    this.suffixIcon,
    this.onTapOutside,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(
      AppDimens.customSpacing20,
    ),
  });

  final String label;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppDimens.customSpacing4),
          child: Text(
            label,
            style: TextStyleManager.regular(
              color: AppColors.black,
              size: AppDimens.textSize12pt,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        CustomTextFormField(
            hintText: hintText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            readOnly: readOnly,
            autofocus: autofocus,
            controller: controller,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            onTap: onTap,
            onTapOutside: onTapOutside,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            minLines: minLines,
            suffixIcon: suffixIcon,
            focusNode: focusNode,
            scrollPadding: scrollPadding),
      ],
    );
  }
}
