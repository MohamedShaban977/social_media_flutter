import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';

class InputHashtagsWidget extends ConsumerWidget {
  const InputHashtagsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputHashtags = ref.watch(PostCreationViewModel.inputHashtagsProvider);
    return Text(
      inputHashtags,
      style: TextStyleManager.bold(
        size: AppDimens.textSize14pt,
      ),
    );
  }
}
