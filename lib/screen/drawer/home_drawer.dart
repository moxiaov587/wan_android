import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../app/provider/view_state.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../router/data/app_routes.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../screen/provider/locale_provider.dart';
import '../../screen/provider/theme_provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/screen_utils.dart';
import '../../widget/animated_counter.dart';
import '../../widget/gap.dart';
import '../../widget/indent_divider.dart';
import '../../widget/level_tag.dart';
import '../../widget/sliver_child_with_separator_builder_delegate.dart';
import '../../widget/view_state_widget.dart';
import 'my_collections/my_collections_screen.dart';
import 'provider/drawer_provider.dart';

export 'my_collections/my_collections_screen.dart';
export 'my_share/my_share_screen.dart';

part 'about_screen.dart';
part 'languages_screen.dart';
part 'my_points_screen.dart';
part 'rank_screen.dart';
part 'settings_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final List<ListTileConfig> configs = <ListTileConfig>[
      ListTileConfig(
        iconData: IconFontIcons.coinLine,
        title: S.of(context).myPoints,
        onTap: () {
          const MyPointsRoute().push(context);
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.starLine,
        title: S.of(context).myCollections,
        onTap: () {
          const MyCollectionsRoute(type: CollectionType.article).push(context);
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.shareCircleLine,
        title: S.of(context).myShare,
        onTap: () {
          const MyShareRoute().push(context);
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.informationLine,
        title: S.of(context).about,
        onTap: () {
          const AboutRoute().push(context);
        },
      ),
    ];

    const double avatarRadius = 30.0;

    return Drawer(
      elevation: 0.0,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Consumer(
                builder: (_, WidgetRef ref, Widget? child) {
                  final String? name = ref.watch(
                    authorizedProvider.select(
                      (UserInfoModel? userInfo) =>
                          userInfo?.user.nickname.strictValue ??
                          userInfo?.user.publicName.strictValue,
                    ),
                  );

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      child!,
                      CircleAvatar(
                        backgroundColor: context.theme.dividerColor,
                        radius: avatarRadius,
                        child: name != null
                            ? Text(
                                name.substring(0, 1).toUpperCase(),
                                style: context.theme.textTheme.titleLarge,
                              )
                            : Icon(
                                IconFontIcons.userFill,
                                size: avatarRadius,
                                color: context
                                    .theme.textTheme.displayMedium!.color,
                              ),
                      ),
                      Gap(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name ?? S.of(context).noLogin,
                            style: context.theme.textTheme.titleMedium,
                          ),
                          if (name != null)
                            Gap(
                              direction: GapDirection.horizontal,
                              size: GapSize.small,
                            ),
                          if (name != null)
                            Consumer(
                              builder: (_, WidgetRef ref, __) {
                                final int? level = ref.watch(
                                  authorizedProvider.select(
                                    (UserInfoModel? value) =>
                                        value?.userPoints.level,
                                  ),
                                );

                                return LevelTag(
                                  level: level,
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  );
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      const RankRoute().push(context);
                    },
                    icon: const Icon(IconFontIcons.honourLine),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildWithSeparatorBuilderDelegate(
              (_, int index) {
                final ListTileConfig config = configs[index];

                return ListTile(
                  minLeadingWidth: 24.0,
                  leading: Icon(config.iconData),
                  title: Text(config.title),
                  onTap: config.onTap,
                );
              },
              separatorBuilder: (_, __) => const IndentDivider.listTile(),
              childCount: configs.length,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final ThemeMode current = ref.watch(themeProvider);

                        final bool isDark = current == ThemeMode.dark ||
                            current == ThemeMode.system && context.isDarkTheme;

                        final ThemeMode reverse =
                            isDark ? ThemeMode.light : ThemeMode.dark;

                        return IconButton(
                          onPressed: () {
                            ref.read(themeProvider.notifier).switchThemeMode(
                                  reverse,
                                );
                          },
                          tooltip: S.of(context).themeMode(reverse.name),
                          icon: Icon(
                            isDark
                                ? IconFontIcons.sunFill
                                : IconFontIcons.moonLine,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        const SettingsRoute().push(context);
                      },
                      tooltip: S.of(context).settings,
                      icon: const Icon(IconFontIcons.settingsLine),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtils.bottomSafeHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListTileConfig {
  ListTileConfig({
    required this.iconData,
    required this.title,
    required this.onTap,
  });

  final IconData iconData;
  final String title;
  final VoidCallback onTap;
}
