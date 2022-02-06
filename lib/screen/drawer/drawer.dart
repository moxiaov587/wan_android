import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/view_state.dart';
import '../../app/provider/widget/provider_widget.dart';
import '../../app/theme/theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../contacts/unicode.dart';
import '../../database/hive_boxes.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../navigator/router_delegate.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../screen/provider/locale_provider.dart';
import '../../screen/provider/theme_provider.dart';
import '../../utils/dialog.dart';
import '../../utils/screen.dart';
import '../../widget/animated_counter.dart';
import '../../widget/custom_sliver_child_builder_delegate.dart';
import '../../widget/gap.dart';
import 'provider/drawer_provider.dart';

export 'my_collections/my_collections.dart';
export 'my_share/my_share.dart';

part 'about.dart';
part 'languages.dart';
part 'my_points.dart';
part 'rank.dart';
part 'settings.dart';

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

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
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
                  const CircleAvatar(
                    radius: avatarRadius,
                    child: Icon(
                      IconFontIcons.userFill,
                      size: avatarRadius,
                    ),
                  ),
                  Gap(),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final String? nickname = ref.watch(
                          authorizedProvider.select(
                              (UserInfoModel? value) => value?.user.username));

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            nickname ?? S.of(context).noLogin,
                            style: currentTheme.textTheme.titleMedium,
                          ),
                          if (nickname != null)
                            Gap(
                              direction: GapDirection.horizontal,
                              size: GapSize.small,
                            ),
                          if (nickname != null)
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
                      );
                    },
                  ),
                ],
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
                            themeMode == ThemeMode.system && currentIsDark;

                        return IconButton(
                          onPressed: () {
                            final int index = isDark ? 1 : 2;
                            ref
                                .read(themeProvider.notifier)
                                .switchThemes(index);
                          },
                          icon: Icon(isDark
                              ? IconFontIcons.sunFill
                              : IconFontIcons.moonLine),
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
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtils.bottomSafeHeight,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelTag extends StatelessWidget {
  const _LevelTag({
    Key? key,
    int? level,
  })  : _level = level ?? 1,
        super(key: key);

  final int _level;

  @override
  Widget build(BuildContext context) {
    late Color color;

    if (_level >= 750) {
      color = currentTheme.errorColor;
    } else if (_level < 750 && _level >= 500) {
      color = currentTheme.colorScheme.tertiary;
    } else if (_level < 500 && _level >= 250) {
      color = currentTheme.primaryColor;
    } else {
      color = currentTheme.colorScheme.secondary;
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
        style: currentTheme.textTheme.labelMedium!.copyWith(
          color: currentTheme.tooltipTheme.textStyle!.color,
        ),
      ),
    );
  }
}
