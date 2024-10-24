import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/enums/alert_dialog_type.dart';
import 'package:hauui_flutter/core/constants/enums/image_type.dart';
import 'package:hauui_flutter/core/constants/enums/snackbar_message_type.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/block_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_dialog.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_snack_bar.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_button.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:uiblock/uiblock.dart';

import '/core/constants/app_dimens.dart';
import '/core/constants/app_images.dart';

extension ContextExtensions on BuildContext {
  void showNativeSnackBar({
    required String text,
    bool shouldClearSnackBars = false,
  }) {
    if (shouldClearSnackBars) {
      ScaffoldMessenger.of(this).clearSnackBars();
    }
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          text,
        ),
      ),
    );
  }

  void showCustomSnackBar({
    SnackBarMessageType messageType = SnackBarMessageType.error,
    required String text,
    bool shouldClearSnackBars = false,
    Widget? suffixWidget,
    bool showOnTop = false,
  }) {
    String? icon;
    Color? color;
    if (messageType == SnackBarMessageType.success) {
      color = AppColors.brightCyan;
    } else if (messageType == SnackBarMessageType.info) {
      icon = AppSvg.icInfoTransparentRoundedWhite;
      color = AppColors.white;
    } else if (messageType == SnackBarMessageType.error) {
      color = AppColors.lightRed;
    } else {
      color = AppColors.white;
    }
    if (shouldClearSnackBars) {
      ScaffoldMessenger.of(this).clearSnackBars();
    }
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        margin: showOnTop
            ? EdgeInsets.only(
                left: AppDimens.spacingNormal,
                right: AppDimens.spacingNormal,
                bottom: height - 150,
              )
            : EdgeInsets.zero,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimens.spacingNormal,
          vertical: AppDimens.spacingSmall,
        ),
        elevation: 6.0,
        backgroundColor: AppColors.veryDarkGrayishBlue,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              AppDimens.cornerRadius8pt,
            ),
          ),
        ),
        content: CustomSnackBar(
          messageType: messageType,
          icon: icon,
          text: text,
          color: color,
        ),
      ),
    );
  }

  Future<void> showAdaptiveDialog({
    String? title,
    String? content,
    String? negativeBtnName,
    void Function()? negativeBtnAction,
    String? positiveBtnName,
    Future<void> Function()? positiveBtnAction,
    bool cancelable = false,
  }) async {
    final alertDialog = AlertDialog.adaptive(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: title == null
          ? null
          : Text(
              title,
              style: TextStyleManager.medium(
                size: AppDimens.textSize20pt,
                color: AppColors.black.withOpacity(
                  0.87,
                ),
              ),
            ),
      content: content == null
          ? null
          : Text(
              content,
              style: TextStyleManager.regular(
                size: AppDimens.textSize16pt,
                color: AppColors.black.withOpacity(
                  0.54,
                ),
              ),
            ),
      actions: [
        if (negativeBtnName != null)
          CustomTextButton(
            label: negativeBtnName.toUpperCase(),
            foregroundColor: AppColors.primary,
            textStyle: TextStyleManager.medium(
              size: AppDimens.textSize14pt,
            ),
            onPressed: () {
              if (negativeBtnAction != null) negativeBtnAction();
              Navigator.pop(this);
            },
          ),
        if (positiveBtnName != null)
          CustomTextButton(
            label: positiveBtnName.toUpperCase(),
            foregroundColor: AppColors.primary,
            textStyle: TextStyleManager.medium(
              size: AppDimens.textSize14pt,
            ),
            onPressed: () async {
              await positiveBtnAction?.call();
              Navigator.pop(this);
            },
          ),
      ],
    );
    await showDialog(
      context: this,
      builder: (ctx) => alertDialog,
      barrierDismissible: cancelable,
    );
  }

  Future<void> showCustomDialog({
    AlertDialogType alertDialogType = AlertDialogType.destructive,
    String? icon,
    ImageType iconType = ImageType.svg,
    Color? iconColor,
    String? title,
    String? subTitle,
    String? content,
    String? negativeBtnName,
    void Function()? negativeBtnAction,
    String? positiveBtnName,
    void Function()? positiveBtnAction,
    bool cancelable = false,
  }) {
    final CustomDialog alertdialog;
    if (alertDialogType == AlertDialogType.normal) {
      alertdialog = CustomDialog.normal(
        icon: icon,
        iconType: iconType,
        iconColor: iconColor,
        title: title,
        subTitle: subTitle,
        content: content,
        negativeBtnName: negativeBtnName,
        negativeBtnAction: negativeBtnAction,
        positiveBtnName: positiveBtnName,
        positiveBtnAction: positiveBtnAction,
      );
    } else if (alertDialogType == AlertDialogType.constructive) {
      alertdialog = CustomDialog.constructive(
        icon: icon,
        iconType: iconType,
        iconColor: iconColor,
        title: title,
        subTitle: subTitle,
        content: content,
        negativeBtnName: negativeBtnName,
        negativeBtnAction: negativeBtnAction,
        positiveBtnName: positiveBtnName,
        positiveBtnAction: positiveBtnAction,
      );
    } else {
      alertdialog = CustomDialog.destructive(
        icon: icon,
        iconType: iconType,
        iconColor: iconColor,
        title: title,
        subTitle: subTitle,
        content: content,
        negativeBtnName: negativeBtnName,
        negativeBtnAction: negativeBtnAction,
        positiveBtnName: positiveBtnName,
        positiveBtnAction: positiveBtnAction,
      );
    }

    return showDialog(
      context: this,
      builder: (ctx) => alertdialog,
      barrierDismissible: cancelable,
    );
  }

  Future<dynamic> showBottomSheet({
    required Widget widget,
    bool isScrollControlled = true,
    bool isDraggable = true,
    Color backgroundColor = AppColors.transparent,
    // bool useRootNavigator = false,
  }) =>
      showModalBottomSheet(
        context: this,
        isScrollControlled: isScrollControlled,
        enableDrag: isDraggable,
        backgroundColor: backgroundColor,
        // useRootNavigator: useRootNavigator,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppDimens.cornerRadius16pt,
            ),
          ),
        ),
        builder: (_) => widget,
      );

  void showToast({
    required String message,
    Toast duration = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: duration,
      timeInSecForIosWeb: AppConstants.toastDurationForIosWeb,
      gravity: gravity,
      backgroundColor: AppColors.veryDarkGrayishBlue,
      textColor: Colors.white,
      fontSize: AppDimens.textSize14pt,
    );
  }

  //It is required to use the default toast in the current project. So I commented this method to avoid using it by mistake
/*  void showCustomToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    FToast().init(this).showToast(
          gravity: gravity,
          child: CustomToast(
            message: message,
          ),
        );
  }*/

  Future<void> presentDatePicker({
    required Function(DateTime) onDatePicked,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    var pickedDate = await showDatePicker(
      context: this,
      initialDate: initialDate != null
          ? DateTime(
              initialDate.year,
              initialDate.month,
              initialDate.day,
            )
          : DateTime.now(),
      firstDate: firstDate != null
          ? DateTime(
              firstDate.year,
              firstDate.month,
              firstDate.day,
            )
          : DateTime(1900),
      lastDate: lastDate != null
          ? DateTime(
              lastDate.year,
              lastDate.month,
              lastDate.day,
            )
          : DateTime.now(),
      // fieldHintText: 'dd/MM/yyyy',
      // locale: const Locale('en', 'GB'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
                // primary: AppColors.,
                // onPrimary: AppColors.,
                // surface: AppColors.,
                // onSurface: AppColors.,
                ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      onDatePicked(
        pickedDate,
      );
    }
  }

  Future<void> presentTimePicker({
    required Function(TimeOfDay) onTimePicked,
    TimeOfDay? initialTime,
  }) async {
    var pickedTime = await showTimePicker(
      context: this,
      initialTime: initialTime != null
          ? TimeOfDay(
              hour: initialTime.hour,
              minute: initialTime.minute,
            )
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
                // primary: AppColors.,
                // onPrimary: AppColors.,
                // surface: AppColors.,
                // onSurface: AppColors.,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      onTimePicked(
        pickedTime,
      );
    }
  }

  void presentCountryPicker(TextEditingController countryCodeController) {
    showCountryPicker(
      context: this,
      showPhoneCode: true,
      showSearch: false,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: height * 0.4,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius16pt),
        padding: const EdgeInsets.only(top: AppDimens.spacingSmall),
      ),
      favorite: ['EG', 'SA'],
      onSelect: (Country country) => countryCodeController.text = '+${country.phoneCode}',
      onClosed: () => FocusScope.of(this).unfocus(),
    );
  }

  bool isLightMode() => MediaQuery.of(this).platformBrightness == Brightness.light;

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      if (mounted) {
        showCustomSnackBar(
          text: LocaleKeys.noInternetConnection.tr(),
        );
      }
      return false;
    }
  }

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get topPadding => MediaQuery.of(this).viewPadding.top;

  double get bottomPadding => MediaQuery.of(this).viewInsets.bottom;

  double get appBarH => AppBar().preferredSize.height;

  double get heightBody => height - topPadding - bottomPadding - appBarH;

  double get heightBodyWithNav => height - topPadding - bottomPadding - appBarH - 65;

  bool get isSmallDevice => height < 700;

  TargetPlatform get platform => Theme.of(this).platform;

  void block({IconData? backIcon}) => UIBlock.block(
        this,
        canDissmissOnBack: true,
        childBuilder: (_) => BlockWidget(
          backIcon: backIcon,
        ),
      );

  void unblock() => UIBlock.unblock(this);
}
