import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_button.dart';

class TimerButtonWidget extends StatefulWidget {
  const TimerButtonWidget({super.key, required this.timer, this.title, required this.onResendPressed});

  final int timer;

  final String? title;

  final Future<void> Function() onResendPressed;

  @override
  State<TimerButtonWidget> createState() => _TimerButtonWidgetState();
}

class _TimerButtonWidgetState extends State<TimerButtonWidget> {
  late Timer _timer;

  late final ValueNotifier<int> _secondsRemaining;

  late final ValueNotifier<bool> _enableResend;

  @override
  initState() {
    super.initState();
    _secondsRemaining = ValueNotifier<int>(widget.timer);
    _enableResend = ValueNotifier<bool>(false);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining.value != 0) {
        _secondsRemaining.value--;
      } else {
        _enableResend.value = true;
      }
    });
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _enableResend,
          builder: (context, enableResend, _) {
            return CustomTextButton(
              onPressed: enableResend ? _resendCode : null,
              label: widget.title ?? LocaleKeys.resendCode.tr(),
              foregroundColor: AppColors.primary,
              textStyle: TextStyleManager.regular(
                size: AppDimens.textSize14pt,
                color: enableResend ? AppColors.primary : AppColors.grayishBlue,
              ),
            );
          },
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        ValueListenableBuilder(
            valueListenable: _secondsRemaining,
            builder: (context, secondsRemaining, child) {
              return secondsRemaining != 0
                  ? Text(
                      LocaleKeys.seconds.tr(args: [secondsRemaining.toString()]),
                      textAlign: TextAlign.center,
                      style: TextStyleManager.light(
                        color: AppColors.grayishBlue,
                        size: AppDimens.textSize16pt,
                      ),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    );
  }

  Future<void> _resendCode() async {
    await widget.onResendPressed();
    _secondsRemaining.value = widget.timer;
    _enableResend.value = false;
  }
}
