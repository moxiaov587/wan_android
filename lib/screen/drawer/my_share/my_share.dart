import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/view_state.dart';
import '../../../app/provider/widget/provider_widget.dart';
import '../../../app/theme/theme.dart';
import '../../../contacts/icon_font_icons.dart';
import '../../../contacts/instances.dart';
import '../../../extensions/extensions.dart';
import '../../../model/models.dart';
import '../../../navigator/router_delegate.dart';
import '../../../utils/screen.dart';
import '../../../widget/article.dart';
import '../../../widget/custom_sliver_child_builder_delegate.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/dismissible_slidable_action.dart';
import '../../../widget/gap.dart';
import '../provider/drawer_provider.dart';

part 'handle_shared_bottom_sheet.dart';

class MyShareScreen extends StatelessWidget {
  const MyShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myShare),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              AppRouterDelegate.instance.currentBeamState.updateWith(
                showHandleSharedBottomSheet: true,
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
        child: AutoDisposeRefreshListViewWidget<
            AutoDisposeStateNotifierProvider<MyShareArticlesNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel>(
          provider: myShareArticlesProvider,
          onInitState: (Reader reader) {
            reader.call(myShareArticlesProvider.notifier).initData();
          },
          builder: (_, WidgetRef ref, List<ArticleModel> list) {
            return SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  return ProviderScope(
                    overrides: <Override>[
                      _currentShareArticleProvider.overrideWithValue(
                        ref.watch(myShareArticlesProvider).whenOrNull(
                              (_, __, List<ArticleModel> list) => list[index],
                            ),
                      ),
                    ],
                    child: _ShareArticleTile(
                      key: ValueKey<int>(list[index].id),
                    ),
                  );
                },
                itemCount: list.length,
              ),
            );
          },
        ),
      ),
    );
  }
}

final AutoDisposeProvider<ArticleModel?> _currentShareArticleProvider =
    Provider.autoDispose<ArticleModel?>((_) => null);

class _ShareArticleTile extends ConsumerWidget {
  const _ShareArticleTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ArticleModel? article = ref.read(_currentShareArticleProvider);
    return article == null || article.isDestroy
        ? const SizedBox.shrink()
        : Slidable(
            key: ValueKey<int>(article.id),
            endActionPane: ActionPane(
              extentRatio: .45,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                closeOnCancel: true,
                dismissThreshold: .65,
                dismissalDuration: const Duration(milliseconds: 500),
                onDismissed: () {
                  ref
                      .read(myShareArticlesProvider.notifier)
                      .destroy(article.id);
                },
                confirmDismiss: () => ref
                    .read(myShareArticlesProvider.notifier)
                    .requestDeleteShare(
                      articleId: article.id,
                    ),
              ),
              children: <Widget>[
                DismissibleSlidableAction(
                  slidableExtentRatio: .25,
                  dismissiblePaneThreshold: .65,
                  label: '',
                  color: currentTheme.colorScheme.tertiary,
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
