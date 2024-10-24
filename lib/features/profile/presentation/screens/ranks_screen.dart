import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/authentication/login/data/models/rank_model.dart';
import 'package:hauui_flutter/features/profile/presentation/screens/ranks_view_model.dart';
import 'package:hauui_flutter/features/profile/presentation/widgets/cell_rank.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class RanksScreen extends ConsumerStatefulWidget {
  final String? Function({
    required int rankId,
  }) getRankImage;

  const RanksScreen({
    super.key,
    required this.getRankImage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<RanksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getRanks();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<RankModel>>>(
      RanksViewModel.ranksProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => _onBackTapped(
            context: context,
          ),
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          LocaleKeys.hauuiLevels.tr(),
        ),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final ranks = ref.watch(RanksViewModel.ranksProvider);
          return ranks.when(
            data: (data) => data.isEmpty
                ? const SizedBox.shrink()
                : ListView.separated(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.spacingNormal,
                      vertical: AppDimens.spacingNormal,
                    ),
                    itemBuilder: (BuildContext context, int index) => CellRank(
                      rank: data[index],
                      rankImage: widget.getRankImage(
                        rankId: data[index].id ?? -1,
                      ),
                    ),
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: AppDimens.customSpacing12,
                      ),
                    ),
                    itemCount: data.length,
                  ),
            error: (error, stackTrace) => const SizedBox.shrink(),
            loading: () => const CustomProgressIndicator(),
          );
        },
      ),
    );
  }

  void _onBackTapped({
    required BuildContext context,
  }) =>
      Navigator.pop(context);

  Future<void> _getRanks() async => await ref
      .read(
        RanksViewModel.ranksProvider.notifier,
      )
      .getRanks();
}
