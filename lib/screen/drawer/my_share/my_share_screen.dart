import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/mixin/refresh_list_view_state_mixin.dart';
import '../../../app/provider/view_state.dart';
import '../../../app/theme/app_theme.dart';
import '../../../contacts/icon_font_icons.dart';
import '../../../extensions/extensions.dart';
import '../../../model/models.dart';
import '../../../router/data/app_routes.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../../widget/article.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/dismissible_slidable_action.dart';
import '../../../widget/gap.dart';
import '../../../widget/indent_divider.dart';
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
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<MyShareArticlesNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            MyShareScreen> {
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
            icon: const Icon(
              IconFontIcons.addLine,
              size: 30.0,
            ),
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
                (
                  int nextPageNum,
                  bool isLastPage,
                  List<ArticleModel> list,
                ) {
                  list = list
                      .where((ArticleModel article) => article.collect)
                      .toList();

                  if (list.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyWidget(),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtils.bottomSafeHeight,
                    ),
                    sliver: SlidableAutoCloseBehavior(
                      child: LoadMoreSliverList.separator(
                        loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                        itemBuilder: (_, int index) {
                          final ArticleModel article = list[index];

                          return _ShareArticleTile(
                            key: Key('my_share_article_${article.id}'),
                            article: article,
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
                        separatorBuilder: (_, __) => const IndentDivider(),
                        itemCount: list.length,
                      ),
                    ),
                  );
                },
                loading: loadingIndicatorBuilder,
                error: errorIndicatorBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AutoDisposeStateNotifierProvider<MyShareArticlesNotifier,
          RefreshListViewState<ArticleModel>>
      get provider => myShareArticlesProvider;
}

class _ShareArticleTile extends ConsumerWidget {
  const _ShareArticleTile({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: key,
      groupTag: 'share_article',
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        extentRatio: 0.45,
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          dismissThreshold: 0.65,
          dismissalDuration: const Duration(milliseconds: 500),
          onDismissed: () {
            ref.read(myShareArticlesProvider.notifier).destroy(article.id);
          },
          confirmDismiss: () async {
            final bool? result = await DialogUtils.confirm<bool>(
              isDanger: true,
              builder: (BuildContext context) {
                return Text(S.of(context).removeShareTips);
              },
              confirmCallback: () async {
                final bool result = await ref
                    .read(myShareArticlesProvider.notifier)
                    .requestDeleteShare(
                      articleId: article.id,
                    );

                return result;
              },
            );

            return result ?? false;
          },
        ),
        children: <Widget>[
          DismissibleSlidableAction(
            slidableExtentRatio: 0.25,
            dismissiblePaneThreshold: 0.65,
            label: '',
            color: context.theme.colorScheme.tertiary,
            onTap: () {},
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: ScreenUtils.width,
        ),
        child: ArticleTile(
          article: article,
        ),
      ),
    );
  }
}
