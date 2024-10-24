import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

class CustomCheckboxFormField extends FormField<bool> {
  CustomCheckboxFormField({
    super.key,
    required Widget title,
    super.onSaved,
    super.validator,
    bool showErrorMessage = true,
    bool super.initialValue = false,
    bool autoValidate = false,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: AppDimens.widgetDimen24pt,
                      height: AppDimens.widgetDimen24pt,
                      child: Checkbox(
                        value: state.value,
                        onChanged: state.didChange,
                      ),
                    ),
                    const SizedBox(
                      width: AppDimens.widgetDimen16pt,
                    ),
                    title,
                  ],
                ),
                if (state.hasError && showErrorMessage) ...[
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  Builder(
                    builder: (BuildContext context) => Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                ]
              ],
            );
          },
        );
}
