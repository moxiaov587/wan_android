import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/view_state.dart';
import '../../app/provider/widget/provider_widget.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/unicode.dart';
import '../../database/hive_boxes.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../navigator/app_router_delegate.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../screen/provider/locale_provider.dart';
import '../../screen/provider/theme_provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/screen_utils.dart';
import '../../widget/animated_counter.dart';
import '../../widget/custom_sliver_child_builder_delegate.dart';
import '../../widget/gap.dart';
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
          AppRouterDelegate.instance.currentBeamState.updateWith(
            isMyPoints: true,
          );
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.starLine,
        title: S.of(context).myCollections,
        onTap: () {
          AppRouterDelegate.instance.currentBeamState.updateWith(
            isMyCollections: true,
          );
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.shareCircleLine,
        title: S.of(context).myShare,
        onTap: () {
          AppRouterDelegate.instance.currentBeamState.updateWith(
            isMyShare: true,
          );
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.informationLine,
        title: S.of(context).about,
        onTap: () {
          AppRouterDelegate.instance.currentBeamState.updateWith(
            isAbout: true,
          );
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

                                return _LevelTag(
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
                      AppRouterDelegate.instance.currentBeamState.updateWith(
                        isRank: true,
                      );
                    },
                    icon: const Icon(IconFontIcons.honourLine),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: CustomSliverChildBuilderDelegate.separated(
              itemCount: configs.length,
              itemBuilder: (_, int index) {
                final ListTileConfig config = configs[index];

                return ListTile(
                  minLeadingWidth: 24.0,
                  leading: Icon(config.iconData),
                  title: Text(config.title),
                  onTap: config.onTap,
                );
              },
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
                        final ThemeMode themeMode = ref.watch(themeProvider);

                        final bool isDark = themeMode == ThemeMode.dark ||
                            themeMode == ThemeMode.system &&
                                context.isDarkTheme;

                        return IconButton(
                          onPressed: () {
                            final int index = isDark ? 1 : 2;
                            ref
                                .read(themeProvider.notifier)
                                .switchThemes(index);
                          },
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
                        AppRouterDelegate.instance.currentBeamState.updateWith(
                          isSettings: true,
                        );
                      },
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

class _LevelTag extends StatelessWidget {
  const _LevelTag({
    int? level,
  }) : _level = level ?? 1;

  final int _level;

  @override
  Widget build(BuildContext context) {
    late Color color;

    if (_level >= 750) {
      color = context.theme.errorColor;
    } else if (_level < 750 && _level >= 500) {
      color = context.theme.colorScheme.tertiary;
    } else if (_level < 500 && _level >= 250) {
      color = context.theme.primaryColor;
    } else {
      color = context.theme.colorScheme.secondary;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppTheme.adornmentBorderRadius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kStyleUint,
        vertical: kStyleUint / 2,
      ),
      child: Text(
        'Lv${Unicode.halfWidthSpace}$_level',
        style: context.theme.textTheme.labelMedium!.copyWith(
          color: context.theme.tooltipTheme.textStyle!.color,
        ),
      ),
    );
  }
}
