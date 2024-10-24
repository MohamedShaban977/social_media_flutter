import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;

  final Widget? prefixIcon;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool shouldHideBorder;
  final EdgeInsetsDirectional? contentPadding;
  final String counterText;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;

  const CustomTextField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.hintStyle,
    this.style,
    this.maxLength,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.shouldHideBorder = false,
    this.contentPadding,
    this.counterText = '',
    this.onTap,
    this.onTapOutside,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minHeight: AppDimens.zero,
          minWidth: AppDimens.zero,
        ),
        hintText: hintText,
        hintStyle: hintStyle,
        border: shouldHideBorder ? InputBorder.none : null,
        focusedBorder: shouldHideBorder ? InputBorder.none : null,
        enabledBorder: shouldHideBorder ? InputBorder.none : null,
        errorBorder: shouldHideBorder ? InputBorder.none : null,
        disabledBorder: shouldHideBorder ? InputBorder.none : null,
        contentPadding: contentPadding,
        counterText: counterText,
      ),
      onTap: onTap,
      onTapOutside: onTapOutside ?? (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
