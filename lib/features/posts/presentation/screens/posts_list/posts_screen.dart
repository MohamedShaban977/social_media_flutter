import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_tabbed_widget.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/main_layout/presentation/widgets/tool_bar_widget.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/discover_posts_widget.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/list_posts.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
      animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ToolBarWidget(showAppLogo: true, title: LocaleKeys.appName.tr()),
          Expanded(
            child: Stack(
              children: [
                CustomTabbedWidget(
                  tabController: _tabController,
                  tabsLabels: [LocaleKeys.forYou.tr(), LocaleKeys.popular.tr(), LocaleKeys.discover.tr()],
                  currentTabIndex: 0,
                  dividerHeight: AppDimens.dividerThickness0Point1pt,
                  children: const [ListPosts.forYou(), ListPosts.popular(), DiscoverPostsWidget()],
                ),
                PositionedDirectional(
                  end: 0,
                  top: 0,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final accountMode = ref.read(AccountViewModel.accountModeProvider);
                      return InkWell(
                        onTap: () {
                          if (accountMode == AccountMode.authorized) {
                            Scaffold.of(context).openEndDrawer();
                          } else {
                            context.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: AppDimens.spacingNormal),
                          child: CustomImage.svg(src: AppSvg.icFavoriteHobbies),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
