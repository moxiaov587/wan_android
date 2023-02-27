import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;

import '../../../widget/view_state_widget.dart';
import '../provider.dart';
import '../view_state.dart';
import '../widget/pull_to_refresh_widgets.dart';

mixin RefreshListViewStateMixin<
        ProviderType extends StateNotifierProvider<
            BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
        T,
        ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  final ValueNotifier<LoadingMoreStatus> _loadingMoreStatusNotifier =
      ValueNotifier<LoadingMoreStatus>(LoadingMoreStatus.completed);

  @protected
  ProviderType get provider;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  (_, __, ___) => CupertinoSliverRefreshControl(
                    onRefresh: () {
                      _loadingMoreStatusNotifier.value =
                          LoadingMoreStatus.completed;

                      return ref.watch(provider.notifier).refresh();
                    },
                  ),
                ) ??
            const SliverToBoxAdapter(child: nil),
      );

  Widget get loadMoreIndicator => SliverToBoxAdapter(
        child: ValueListenableBuilder<LoadingMoreStatus>(
          valueListenable: _loadingMoreStatusNotifier,
          builder: (_, LoadingMoreStatus status, __) => LoadingMoreIndicator(
            status: status,
            onRetry: () async {
              _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;
              _loadingMoreStatusNotifier.value =
                  (await ref.read(provider.notifier).loadMore())!;
            },
          ),
        ),
      );

  void onRetry() {
    ref.read(provider.notifier).initData();
  }

  @mustCallSuper
  @override
  void dispose() {
    _loadingMoreStatusNotifier.dispose();

    super.dispose();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if ((ref
                  .read(provider)
                  .whenOrNull((_, __, List<T> list) => list.isNotEmpty) ??
              false) &&
          _loadingMoreStatusNotifier.value == LoadingMoreStatus.completed) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _loadingMoreStatusNotifier.value =
              (await ref.read(provider.notifier).loadMore())!;
        });
      }
    }

    return false;
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withViewError(
          ViewError.create(e, s),
          onRetry: onRetry,
        ),
      );
}

mixin AutoDisposeRefreshListViewStateMixin<
        ProviderType extends AutoDisposeStateNotifierProvider<
            BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
        T,
        ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  final ValueNotifier<LoadingMoreStatus> _loadingMoreStatusNotifier =
      ValueNotifier<LoadingMoreStatus>(LoadingMoreStatus.completed);

  @protected
  ProviderType get provider;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  (_, __, ___) => CupertinoSliverRefreshControl(
                    onRefresh: () {
                      _loadingMoreStatusNotifier.value =
                          LoadingMoreStatus.completed;

                      return ref.watch(provider.notifier).refresh();
                    },
                  ),
                ) ??
            const SliverToBoxAdapter(child: nil),
      );

  Widget get loadMoreIndicator => SliverToBoxAdapter(
        child: ValueListenableBuilder<LoadingMoreStatus>(
          valueListenable: _loadingMoreStatusNotifier,
          builder: (_, LoadingMoreStatus status, __) => LoadingMoreIndicator(
            status: status,
            onRetry: () async {
              _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;
              _loadingMoreStatusNotifier.value =
                  (await ref.read(provider.notifier).loadMore())!;
            },
          ),
        ),
      );

  void onRetry() {
    ref.read(provider.notifier).initData();
  }

  @mustCallSuper
  @override
  void dispose() {
    _loadingMoreStatusNotifier.dispose();

    super.dispose();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if ((ref
                  .read(provider)
                  .whenOrNull((_, __, List<T> list) => list.isNotEmpty) ??
              false) &&
          _loadingMoreStatusNotifier.value == LoadingMoreStatus.completed) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _loadingMoreStatusNotifier.value =
              (await ref.read(provider.notifier).loadMore())!;
        });
      }
    }

    return false;
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withViewError(
          ViewError.create(e, s),
          onRetry: onRetry,
        ),
      );
}
