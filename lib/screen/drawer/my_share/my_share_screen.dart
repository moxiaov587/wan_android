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
import '../../../extensions/extensions.dart';
import '../../../model/models.dart';
import '../../../navigator/app_router_delegate.dart';
import '../../../utils/screen_utils.dart';
import '../../../widget/article.dart';
import '../../../widget/custom_text_form_field.dart';
import '../../../widget/dismissible_slidable_action.dart';
import '../../../widget/gap.dart';
import '../provider/drawer_provider.dart';

part 'handle_shared_bottom_sheet.dart';

class MyShareScreen extends StatelessWidget {
  const MyShareScreen({super.key});

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
          builder: (_, WidgetRef ref, int index, ArticleModel article) {
            return ProviderScope(
              overrides: <Override>[
                _currentShareArticleProvider.overrideWithValue(
                  ref.watch(myShareArticlesProvider).whenOrNull(
                        (_, __, List<ArticleModel> list) => list[index],
                      ),
                ),
              ],
              child: const _ShareArticleTile(),
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
  const _ShareArticleTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ArticleModel? article = ref.read(_currentShareArticleProvider);

    return article == null || article.isDestroy
        ? nil
        : Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.45,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                closeOnCancel: true,
                dismissThreshold: 0.65,
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
                  slidableExtentRatio: 0.25,
                  dismissiblePaneThreshold: 0.65,
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
