import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/profile_mode.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';
import 'package:hauui_flutter/features/profile/presentation/screens/profile_view_model.dart';
import 'package:hauui_flutter/features/profile/presentation/widgets/profile_basic_info_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final ProfileMode profileMode;
  final int? userId;

  const ProfileScreen.me({
    super.key,
  })  : profileMode = ProfileMode.me,
        userId = null;

  const ProfileScreen.user({
    super.key,
    required this.userId,
  }) : profileMode = ProfileMode.user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserModel?>>(
      ProfileViewModel.profileProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    final user = ref.watch(ProfileViewModel.profileProvider);
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
      ),
      body: user.when(
        data: (data) => data == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.spacingNormal,
                    ),
                    child: widget.profileMode == ProfileMode.me
                        ? ProfileBasicInfoWidget.me(
                            user: data,
                          )
                        : ProfileBasicInfoWidget.user(
                            user: data,
                          ),
                  ),
                ],
              ),
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const CustomProgressIndicator(),
      ),
    );
  }

  void _onBackTapped({
    required BuildContext context,
  }) =>
      Navigator.pop(context);

  Future<void> _getProfile() async {
    final userId = widget.profileMode == ProfileMode.me ? UserExtensions.getCachedUser()?.id : widget.userId;
    if (userId != null) {
      await ref
          .read(
            ProfileViewModel.profileProvider.notifier,
          )
          .getProfile(
            userId: userId,
          );
    }
  }
}
