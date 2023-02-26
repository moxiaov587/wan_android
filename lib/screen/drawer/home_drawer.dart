import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../app/provider/view_state.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../database/app_database.dart';
import '../../extensions/extensions.dart';
import '../../model/models.dart';
import '../../router/data/app_routes.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../screen/provider/common_provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/screen_utils.dart';
import '../../widget/animated_counter.dart';
import '../../widget/gap.dart';
import '../../widget/indent_divider.dart';
import '../../widget/level_tag.dart';
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
part 'storage_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                      (AsyncValue<UserInfoModel?> data) =>
                          data.valueOrNull?.user.nickname.strictValue ??
                          data.valueOrNull?.user.publicName.strictValue,
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
                      const Gap.vn(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name ?? S.of(context).noLogin,
                            style: context.theme.textTheme.titleMedium,
                          ),
                          if (name != null)
                            Padding(
                              padding: const EdgeInsets.only(left: kStyleUint2),
                              child: Consumer(
                                builder: (_, WidgetRef ref, __) {
                                  final int? level = ref.watch(
                                    authorizedProvider.select(
                                      (AsyncValue<UserInfoModel?> data) =>
                                          data.valueOrNull?.userPoints.level,
                                    ),
                                  );

                                  return LevelTag(level: level);
                                },
                              ),
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
            delegate: SliverChildListDelegate(
              <Widget>[
                ListTile(
                  leading: const Icon(IconFontIcons.coinLine),
                  title: Text(S.of(context).myPoints),
                  onTap: () {
                    const MyPointsRoute().push(context);
                  },
                ),
                ListTile(
                  leading: const Icon(IconFontIcons.starLine),
                  title: Text(S.of(context).myCollections),
                  onTap: () {
                    const MyCollectionsRoute(
                      type: CollectionType.article,
                    ).push(context);
                  },
                ),
                ListTile(
                  leading: const Icon(IconFontIcons.shareCircleLine),
                  title: Text(S.of(context).myShare),
                  onTap: () {
                    const MyShareRoute().push(context);
                  },
                ),
                ListTile(
                  leading: const Icon(IconFontIcons.informationLine),
                  title: Text(S.of(context).about),
                  onTap: () {
                    const AboutRoute().push(context);
                  },
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
                child: Row(
                  children: <Widget>[
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final ThemeMode current =
                            ref.watch(appThemeModeProvider);

                        final bool isDark = current == ThemeMode.dark ||
                            current == ThemeMode.system && context.isDarkTheme;

                        final ThemeMode reverse =
                            isDark ? ThemeMode.light : ThemeMode.dark;

                        return IconButton(
                          onPressed: () {
                            ref
                                .read(appThemeModeProvider.notifier)
                                .switchThemeMode(reverse);
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
