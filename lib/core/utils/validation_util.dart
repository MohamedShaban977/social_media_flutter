import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'regex_util.dart';

class ValidationUtil {
  static String? isValidEmail(String email) {
    if (email.isEmpty) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (!RegexUtil.rxEmail.hasMatch(email)) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidPassword(String password) {
    if (password.isEmpty) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (password.length < 6) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidPasswordWithValidation(String password) {
    if (password.isEmpty) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (password.length < 8) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (!RegexUtil.rxPassword.hasMatch(password)) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidPhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (value.length < 6) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidPinCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.fieldIsRequired.tr();
    } else if (value.length < 6) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidAgreeToTerms(bool? value) {
    if (!(value!)) {
      return LocaleKeys.fieldIsRequired.tr();
    } else {
      return null;
    }
  }

  static String? isValidInputField(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.pleaseFillThisField.tr();
    } else {
      return null;
    }
  }

  static String? isValidUrl(String? url, {bool isInPerson = false}) {
    if (isInPerson) {
      if (url == null || url.isEmpty) {
        return null;
      } else {
        if (RegexUtil.rxUrl.firstMatch(url) == null) {
          return LocaleKeys.pleaseFillThisField.tr();
        } else {
          return null;
        }
      }
    }
    if (url == null || url.isEmpty || RegexUtil.rxUrl.firstMatch(url) == null) {
      return LocaleKeys.pleaseFillThisField.tr();
    } else {
      return null;
    }
  }
}
