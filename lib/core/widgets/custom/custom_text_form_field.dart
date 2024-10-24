import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
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
    this.prefixIcon,
  });

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
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: onTapOutside ?? (_) => FocusScope.of(context).unfocus(),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      readOnly: readOnly,
      autofocus: autofocus,
      focusNode: focusNode,
      scrollPadding: scrollPadding,
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      onTap: onTap,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      minLines: minLines,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        suffixIconConstraints: const BoxConstraints(maxHeight: 18.0),
        prefixIconConstraints: const BoxConstraints(maxHeight: 50.0),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        errorStyle: const TextStyle(
          height: 0.0,
        ),
        counterText: '',
      ),
    );
  }
}
