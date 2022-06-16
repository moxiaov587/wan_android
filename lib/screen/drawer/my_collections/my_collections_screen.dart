import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nil/nil.dart' show nil;

import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../../app/theme/app_theme.dart';
import '../../../contacts/icon_font_icons.dart';
import '../../../contacts/instances.dart';
import '../../../contacts/unicode.dart';
import '../../../extensions/extensions.dart';
import '../../../model/models.dart';
import '../../../navigator/app_router_delegate.dart';
import '../../../utils/html_parse_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../../widget/custom_sliver_child_builder_delegate.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/dismissible_slidable_action.dart';
import '../../../widget/gap.dart';
import '../../../widget/view_state_widget.dart';
import '../provider/drawer_provider.dart';

part 'article.dart';
part 'handle_collected_bottom_sheet.dart';
part 'website.dart';

class MyCollectionsScreen extends StatefulWidget {
  const MyCollectionsScreen({
    super.key,
    required this.type,
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
  void initState() {
    super.initState();

    _tabController.addListener(_onTabControllerScroll);
  }

  void _onTabControllerScroll() {
    AppRouterDelegate.instance.currentBeamState.updateWith(
      collectionTypeIndex: _tabController.index,
      rebuild: false,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabControllerScroll);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myCollections),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              AppRouterDelegate.instance.currentBeamState.updateWith(
                showHandleCollectedBottomSheet: true,
              );
            },
            icon: const Icon(
              IconFontIcons.addLine,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Material(
              color: currentTheme.appBarTheme.backgroundColor,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                labelStyle: currentTheme.textTheme.titleMedium,
                labelColor: currentTheme.textTheme.titleMedium!.color,
                unselectedLabelStyle: currentTheme.textTheme.titleMedium,
                tabs: CollectionType.values
                    .map((CollectionType e) =>
                        Text(S.of(context).myCollectionsTabs(e.name)))
                    .toList(),
                onTap: (int index) {
                  AppRouterDelegate.instance.currentBeamState.updateWith(
                    collectionTypeIndex: index,
                    rebuild: false,
                  );
                },
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
      ),
    );
  }
}

enum CollectionType {
  article,
  website,
}
