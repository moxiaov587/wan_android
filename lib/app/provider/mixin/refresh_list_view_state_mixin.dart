import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

import '../../../widget/view_state_widget.dart';
import '../provider.dart';
import '../view_state.dart';
import '../widget/pull_to_refresh_widgets.dart';

export 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

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
                    onRefresh: () async {
                      _loadingMoreStatusNotifier.value =
                          LoadingMoreStatus.completed;

                      await ref.watch(provider.notifier).refresh();
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
              _loadingMoreStatusNotifier
                ..value = LoadingMoreStatus.loading
                ..value = (await ref.read(provider.notifier).loadMore()) ??
                    LoadingMoreStatus.completed;
            },
          ),
        ),
      );

  FutureOr<void> onRetry() async {
    await ref.read(provider.notifier).initData();
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
                  .whenOrNull((List<T> list, _, __) => list.isNotEmpty) ??
              false) &&
          _loadingMoreStatusNotifier.value == LoadingMoreStatus.completed) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _loadingMoreStatusNotifier.value =
              (await ref.read(provider.notifier).loadMore()) ??
                  LoadingMoreStatus.completed;
        });
      }
    }

    return false;
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
                    onRefresh: () async {
                      _loadingMoreStatusNotifier.value =
                          LoadingMoreStatus.completed;

                      await ref.watch(provider.notifier).refresh();
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
              _loadingMoreStatusNotifier
                ..value = LoadingMoreStatus.loading
                ..value = (await ref.read(provider.notifier).loadMore()) ??
                    LoadingMoreStatus.completed;
            },
          ),
        ),
      );

  FutureOr<void> onRetry() async {
    await ref.read(provider.notifier).initData();
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
                  .whenOrNull((List<T> list, _, __) => list.isNotEmpty) ??
              false) &&
          _loadingMoreStatusNotifier.value == LoadingMoreStatus.completed) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _loadingMoreStatusNotifier.value =
              (await ref.read(provider.notifier).loadMore()) ??
                  LoadingMoreStatus.completed;
        });
      }
    }

    return false;
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
