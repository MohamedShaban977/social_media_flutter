import 'package:flutter/cupertino.dart';

extension TextEditingControllerExtensions<T> on TextEditingController {
  void appendText({
    required String text,
  }) {
    this.text = this.text + text;
    // Move the cursor to the end of the text
    selection = TextSelection.fromPosition(
      TextPosition(
        offset: this.text.length,
      ),
    );
  }
}
