import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../../widget/view_state_widget.dart';
import '../provider.dart';
import '../view_state.dart';

mixin ListViewStateMixin<
        ProviderType extends StateNotifierProvider<BaseListViewNotifier<T>,
            ListViewState<T>>,
        T,
        ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  @protected
  ProviderType get provider;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  (_) => CupertinoSliverRefreshControl(
                    onRefresh: ref.watch(provider.notifier).refresh,
                  ),
                ) ??
            const SliverToBoxAdapter(child: nil),
      );

  void onRetry() {
    ref.read(provider.notifier).initData();
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget.listView(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withViewError(
          ViewError.create(e, s),
          onRetry: onRetry,
        ),
      );
}

mixin AutoDisposeListViewStateMixin<
        ProviderType extends AutoDisposeStateNotifierProvider<
            BaseListViewNotifier<T>, ListViewState<T>>,
        T,
        ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  @protected
  ProviderType get provider;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  (_) => CupertinoSliverRefreshControl(
                    onRefresh: ref.watch(provider.notifier).refresh,
                  ),
                ) ??
            const SliverToBoxAdapter(child: nil),
      );

  void onRetry() {
    ref.read(provider.notifier).initData();
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget.listView(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withViewError(
          ViewError.create(e, s),
          onRetry: onRetry,
        ),
      );
}
