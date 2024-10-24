import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/text_editing_controller_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/chip_solid_light_grayish_blue2_opacity40_corner14.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/skeleton_list_suggested_hashtags.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:pinput/pinput.dart';

class ListSuggestedHashtags extends ConsumerWidget {
  final TextEditingController hashtagsController;
  final ScrollController scrollController;

  const ListSuggestedHashtags({
    super.key,
    required this.hashtagsController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedHashtags = ref.watch(PostCreationViewModel.suggestedHashtagsProvider);
    return SizedBox(
      height: AppDimens.widgetDimen45pt,
      child: suggestedHashtags.when(
        data: (data) => data.isEmpty
            ? null
            : ListView.separated(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => index == data.length
                    ? ref.read(
                        PostCreationViewModel.isLastSuggestedHashtagsPageProvider,
                      )
                        ? const SizedBox.shrink()
                        : Transform.scale(
                            scale: 0.5,
                            child: const CustomProgressIndicator(),
                          )
                    : InkWell(
                        onTap: () => _onHashtagTapped(
                          hashtag: '${data[index].name}',
                        ),
                        child: ChipSolidLightGrayishBlue2Opacity40Corner14(
                          title: '${data[index].name}',
                        ),
                      ),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: AppDimens.spacingSmall,
                  ),
                ),
                itemCount: data.length + 1,
              ),
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SkeletonListSuggestedHashtags(),
      ),
    );
  }

  void _onHashtagTapped({
    required String hashtag,
  }) {
    if (hashtagsController.length == 0 && !hashtagsController.text.startsWith(LocaleKeys.hashSymbol.tr())) {
      hashtagsController.text = LocaleKeys.hashSymbol.tr();
    } else {
      hashtagsController.text = hashtagsController.text.substring(
        0,
        hashtagsController.text.lastIndexOf(LocaleKeys.hashSymbol.tr()) + 1,
      );
    }
    hashtagsController.appendText(
      text: hashtag,
    );
  }
}
