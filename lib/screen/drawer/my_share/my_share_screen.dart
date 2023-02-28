import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app/l10n/generated/l10n.dart';
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

part 'handle_shared_bottom_sheet.dart';

class MyShareScreen extends ConsumerStatefulWidget {
  const MyShareScreen({super.key});

  @override
  ConsumerState<MyShareScreen> createState() => _MyShareScreenState();
}

class _MyShareScreenState extends ConsumerState<MyShareScreen>
    with
        AutoDisposeRefreshListViewStateMixin<MyShareArticlesProvider,
            ArticleModel, MyShareScreen> {
  @override
  MyShareArticlesProvider get provider => myShareArticlesProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myShare),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              const HandleSharedBottomSheetRoute().push(context);
            },
            icon: const Icon(IconFontIcons.addLine, size: 30.0),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: CustomScrollView(
          slivers: <Widget>[
            pullDownIndicator,
            Consumer(
              builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                (_, __, List<ArticleModel> list) {
                  if (list.isEmpty) {
                    return const SliverFillRemaining(child: EmptyWidget());
                  }

                  return SlidableAutoCloseBehavior(
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, int index) {
                          final ArticleModel article = list[index];

                          return SlidableTile.shareArticle(
                            key: Key('my_share_article_${article.id}'),
                            article: article,
                            onDismissed: () {
                              ref
                                  .read(myShareArticlesProvider.notifier)
                                  .destroy(article.id);
                            },
                            confirmCallback: () async {
                              final bool result = await ref
                                  .read(myShareArticlesProvider.notifier)
                                  .requestDeleteShare(articleId: article.id);

                              return result;
                            },
                          );
                        },
                        findChildIndexCallback: (Key key) {
                          final int index = list.indexWhere(
                            (ArticleModel article) =>
                                key == Key('my_share_article_${article.id}'),
                          );

                          if (index == -1) {
                            return null;
                          }

                          return index;
                        },
                        childCount: list.length,
                      ),
                    ),
                  );
                },
                loading: loadingIndicatorBuilder,
                error: errorIndicatorBuilder,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: ScreenUtils.bottomSafeHeight),
              sliver: loadMoreIndicator,
            ),
          ],
        ),
      ),
    );
  }
}
