import 'dart:async' show Timer;

import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

import '../../../model/models.dart' show PaginationData;
import '../../../widget/view_state_widget.dart';
import '../../http/interceptors/interceptors.dart';
import '../widget/pull_to_refresh_widgets.dart';

export 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

part 'load_more_mixin.dart';

mixin RefreshListViewStateMixin<
        ProviderType extends ProviderBase<AsyncValue<PaginationData<T>>>,
        T,
        ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  final ValueNotifier<LoadingMoreStatus> _loadingMoreStatusNotifier =
      ValueNotifier<LoadingMoreStatus>(LoadingMoreStatus.completed);

  Timer? _throttle;

  @protected
  ProviderType get provider;

  @protected
  Refreshable<Future<PaginationData<T>>> get refreshable;

  @protected
  OnLoadMoreCallback get loadMore;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  data: (_) => CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      _loadingMoreStatusNotifier.value =
                          LoadingMoreStatus.completed;

                      return ref.refresh(refreshable);
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
                ..value = (await loadMore()) ?? LoadingMoreStatus.completed;
            },
          ),
        ),
      );

  FutureOr<void> onRetry() {
    ref.invalidate(provider);
  }

  @mustCallSuper
  @override
  void dispose() {
    _loadingMoreStatusNotifier.dispose();
    _throttle?.cancel();
    _throttle = null;

    super.dispose();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (_throttle?.isActive ?? false) {
      return false;
    }

    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if ((ref.read(provider).whenOrNull(
                    data: (PaginationData<T> data) => data.datas.isNotEmpty,
                  ) ??
              false) &&
          _loadingMoreStatusNotifier.value == LoadingMoreStatus.completed) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _loadingMoreStatusNotifier.value =
              (await loadMore()) ?? LoadingMoreStatus.completed;
        });

        _throttle = Timer(const Duration(seconds: 1), () {});
      }
    }

    return false;
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget.listView(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withAppException(
          AppException.create(e, s),
          onRetry: onRetry,
        ),
      );
}
