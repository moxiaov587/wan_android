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
          builder: (_, __, List<ArticleModel> list) {
            return SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  return Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final bool isDestroy = ref.watch(
                              myShareArticlesProvider.select(
                                  (RefreshListViewState<ArticleModel> value) =>
                                      value.whenOrNull(
                                          (_, __, List<ArticleModel> list) =>
                                              list[index].isDestroy))) ??
                          false;
                      return isDestroy
                          ? const SizedBox.shrink()
                          : Slidable(
                              key: ValueKey<int>(list[index].id),
                              endActionPane: ActionPane(
                                extentRatio: .45,
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(
                                  closeOnCancel: true,
                                  dismissThreshold: .65,
                                  dismissalDuration:
                                      const Duration(milliseconds: 500),
                                  onDismissed: () {
                                    ref
                                        .read(myShareArticlesProvider.notifier)
                                        .destroy(list[index].id);
                                  },
                                  confirmDismiss: () => ref
                                      .read(myShareArticlesProvider.notifier)
                                      .requestDeleteShare(
                                        articleId: list[index].id,
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
                                  article: list[index],
                                ),
                              ),
                            );
                    },
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
