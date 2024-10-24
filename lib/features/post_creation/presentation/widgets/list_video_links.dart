import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/cell_video_link.dart';

class ListVideoLinks extends ConsumerWidget {
  const ListVideoLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLinks = ref.watch(PostCreationViewModel.videoLinksProvider);
    return SliverList.separated(
      itemBuilder: (BuildContext context, int index) => CellVideoLink(
        index: index,
      ),
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: AppDimens.spacingNormal,
        ),
      ),
      itemCount: videoLinks.length,
    );
  }
}
