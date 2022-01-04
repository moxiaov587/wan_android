import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../contacts/instances.dart';
import '../../model/models.dart';
import '../../navigator/route_name.dart';
import '../../navigator/router_delegate.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../widget/gap.dart';

part 'about.dart';
part 'my_collections.dart';
part 'my_points.dart';
part 'my_share.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircleAvatar(
                    radius: avatarRadius,
                    child: Icon(
                      Icons.people_outline,
                      size: avatarRadius,
                    ),
                  ),
                  Gap(),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final String? nickname = ref.watch(authorizedProvider
                          .select((UserModel? value) => value?.nickname));

                      return Text(nickname ?? S.of(context).noLogin);
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final int itemIndex = index ~/ 2;
                final Widget widget;
                if (index.isEven) {
                  widget = ListTile(
                    title: Text(RouterName.homeDrawerTiles[itemIndex].title),
                    onTap: () {
                      AppRouterDelegate.instance.currentBeamState
                          .updateWith(isMyCollections: true);
                    },
                  );
                } else {
                  widget = const Divider(
                    indent: 20,
                    endIndent: 20,
                  );
                }
                return widget;
              },
              childCount: math.max(
                0,
                RouterName.homeDrawerTiles.length * 2 - 1,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Consumer(
                  builder: (_, WidgetRef ref, Widget? title) => ListTile(
                    title: title,
                    onTap: () {
                      ref.read(authorizedProvider.notifier).logout();
                    },
                  ),
                  child: Text(S.of(context).logout),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
