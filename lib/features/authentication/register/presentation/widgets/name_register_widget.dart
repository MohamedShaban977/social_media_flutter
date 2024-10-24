import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/screens/register_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class NameRegisterWidget extends StatelessWidget {
  final TextEditingController nameController;

  NameRegisterWidget({super.key, required this.nameController});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Form(
            key: _formKey,
            onChanged: () => ref
                .read(RegisterViewModel.disableButtonByNameProvider.notifier)
                .update((state) => !_formKey.currentState!.validate()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: AppDimens.widgetDimen155pt,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextFormFieldWithLabelWidget(
                          controller: nameController,
                          label: LocaleKeys.name.tr(),
                          hintText: LocaleKeys.hintName.tr(),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (value) => ValidationUtil.isValidInputField(value)?.empty(),
                          maxLength: 50,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen24pt),
                  Consumer(
                    builder: (context, ref, child) {
                      final disableButton = ref.watch(RegisterViewModel.disableButtonByNameProvider);

                      return ElevatedButton(
                        onPressed: disableButton
                            ? null
                            : () async =>
                                ref.read(RegisterViewModel.indexScreenProvider.notifier).update((state) => state + 1),
                        child: Text(
                          LocaleKeys.next.tr(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
