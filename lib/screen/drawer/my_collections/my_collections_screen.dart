import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/mixin/list_view_state_mixin.dart';
import '../../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../../app/theme/app_theme.dart';
import '../../../contacts/icon_font_icons.dart';
import '../../../extensions/extensions.dart';
import '../../../model/models.dart';
import '../../../router/data/app_routes.dart';
import '../../../utils/screen_utils.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/gap.dart';
import '../../../widget/slidable_tile.dart';
import '../../../widget/view_state_widget.dart';
import '../provider/drawer_provider.dart';

part 'article.dart';
part 'handle_collected_bottom_sheet.dart';
part 'website.dart';

class MyCollectionsScreen extends StatefulWidget {
  const MyCollectionsScreen({
    required this.type,
    super.key,
  });

  final CollectionType type;

  @override
  State<MyCollectionsScreen> createState() => _MyCollectionsScreenState();
}

class _MyCollectionsScreenState extends State<MyCollectionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    initialIndex: widget.type.index,
    length: CollectionType.values.length,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).myCollections),
          actions: <Widget>[
            Consumer(
              builder: (_, WidgetRef ref, __) => IconButton(
                onPressed: () {
                  unawaited(
                    AddCollectedArticleOrWebsiteRoute(
                      type: CollectionType.values[_tabController.index],
                    ).push(context),
                  );
                },
                icon: const Icon(IconFontIcons.addLine, size: 30.0),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Material(
              color: context.theme.appBarTheme.backgroundColor,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: AppTheme.bodyPaddingOnlyVertical,
                labelStyle: context.theme.textTheme.titleMedium,
                labelColor: context.theme.textTheme.titleMedium!.color,
                unselectedLabelStyle: context.theme.textTheme.titleMedium,
                tabs: CollectionType.values
                    .map(
                      (CollectionType type) =>
                          Text(S.of(context).collectionType(type.name)),
                    )
                    .toList(),
                onTap: _tabController.animateTo,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  _Article(),
                  _Website(),
                ],
              ),
            ),
          ],
        ),
      );
}

enum CollectionType {
  article,
  website,
}
