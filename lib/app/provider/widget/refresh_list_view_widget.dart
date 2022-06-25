part of 'provider_widget.dart';

typedef ReaderCallback = void Function(Reader reader);

typedef ListViewItemBuilder<T> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  int index,
  T item,
);

typedef ListViewSeparatorBuilder = Widget Function(
  BuildContext context,
  WidgetRef ref,
  int index,
);

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class RefreshListViewWidget<
    ProviderType extends StateNotifierProvider<BaseRefreshListViewNotifier<T>,
        RefreshListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const RefreshListViewWidget({
    super.key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.separatorBuilder,
    this.sliverPersistentHeader,
    this.slivers = const <Widget>[],
    this.onRetry,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.semanticChildCount,
    this.padding = EdgeInsets.zero,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.lastChildLayoutTypeBuilder,
    this.collectGarbage,
    this.viewportBuilder,
    this.closeToTrailing,
  });

  final ProviderType provider;
  final ReaderCallback? onInitState;
  final ListViewItemBuilder<T> builder;
  final ListViewSeparatorBuilder? separatorBuilder;
  final Widget? sliverPersistentHeader;
  final List<Widget> slivers;
  final ReaderCallback? onRetry;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final double? cacheExtent;
  final int? semanticChildCount;
  final EdgeInsetsGeometry padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final LastChildLayoutTypeBuilder? lastChildLayoutTypeBuilder;
  final CollectGarbage? collectGarbage;
  final ViewportBuilder? viewportBuilder;
  final bool? closeToTrailing;

  @override
  _RefreshListViewWidgetState<ProviderType, T> createState() =>
      _RefreshListViewWidgetState<ProviderType, T>();
}

class _RefreshListViewWidgetState<
    ProviderType extends StateNotifierProvider<BaseRefreshListViewNotifier<T>,
        RefreshListViewState<T>>,
    T> extends ConsumerState<RefreshListViewWidget<ProviderType, T>> {
  final ValueNotifier<LoadingMoreStatus?> _loadingMoreStatusNotifier =
      ValueNotifier<LoadingMoreStatus?>(null);

  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    _loadingMoreStatusNotifier.dispose();

    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if ((ref.read(widget.provider).whenOrNull((_, __, ___) => true) ??
              false) &&
          <LoadingMoreStatus?>[
            LoadingMoreStatus.completed,
            null,
          ].contains(_loadingMoreStatusNotifier.value)) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;
        Future<void>.delayed(Duration.zero, () async {
          _loadingMoreStatusNotifier.value =
              await ref.read(widget.provider.notifier).loadMore();
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          if (widget.sliverPersistentHeader != null)
            widget.sliverPersistentHeader!,
          Consumer(
            builder: (_, WidgetRef ref, Widget? empty) =>
                ref.watch(widget.provider).whenOrNull(
                      (_, __, ___) => CupertinoSliverRefreshControl(
                        onRefresh: () {
                          /// Reset [_loadingMoreStatusNotifier]
                          _loadingMoreStatusNotifier.value = null;

                          return ref.watch(widget.provider.notifier).refresh();
                        },
                      ),
                    ) ??
                empty!,
            child: const SliverToBoxAdapter(child: nil),
          ),
          ...widget.slivers,
          Consumer(
            builder: (_, WidgetRef ref, Widget? loading) => ref
                .watch(widget.provider)
                .when(
                  (int nextPageNum, bool isLastPage, List<T> list) => list
                          .isEmpty
                      ? const SliverFillRemaining(
                          child: EmptyWidget(),
                        )
                      : LoadMoreSliverList<T>(
                          list: list,
                          loadMoreIndicatorBuilder: (_) =>
                              ValueListenableBuilder<LoadingMoreStatus?>(
                            valueListenable: _loadingMoreStatusNotifier,
                            builder: (_, LoadingMoreStatus? status, __) =>
                                LoadingMoreIndicator(
                              status: status,
                              onRetry: () async {
                                _loadingMoreStatusNotifier.value =
                                    LoadingMoreStatus.loading;
                                _loadingMoreStatusNotifier.value = await ref
                                    .read(widget.provider.notifier)
                                    .loadMore();
                              },
                            ),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return widget.builder
                                .call(context, ref, index, list[index]);
                          },
                          separatorBuilder: widget.separatorBuilder != null
                              ? (BuildContext context, int index) =>
                                  widget.separatorBuilder!.call(
                                    context,
                                    ref,
                                    index,
                                  )
                              : null,
                          padding: widget.padding,
                          itemExtent: widget.itemExtent,
                          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                          addRepaintBoundaries: widget.addRepaintBoundaries,
                          addSemanticIndexes: widget.addSemanticIndexes,
                          semanticIndexCallback: widget.semanticIndexCallback,
                          semanticIndexOffset: widget.semanticIndexOffset,
                          lastChildLayoutTypeBuilder:
                              widget.lastChildLayoutTypeBuilder,
                          collectGarbage: widget.collectGarbage,
                          viewportBuilder: widget.viewportBuilder,
                          closeToTrailing: widget.closeToTrailing,
                        ),
                  loading: () => loading!,
                  error: (int? statusCode, String? message, String? detail) =>
                      SliverFillRemaining(
                    child: CustomErrorWidget(
                      statusCode: statusCode,
                      message: message,
                      detail: detail,
                      onRetry: () {
                        if (widget.onRetry != null) {
                          widget.onRetry!.call(ref.read);
                        } else {
                          ref.read(widget.provider.notifier).initData();
                        }
                      },
                    ),
                  ),
                ),
            child: const SliverFillRemaining(
              child: LoadingWidget(),
            ),
          ),
        ],
        semanticChildCount: widget.semanticChildCount,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        primary: widget.primary,
        cacheExtent: widget.cacheExtent,
        controller: widget.controller,
        reverse: widget.reverse,
        dragStartBehavior: widget.dragStartBehavior,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
      ),
    );
  }
}

class AutoDisposeRefreshListViewWidget<
    ProviderType extends AutoDisposeStateNotifierProvider<
        BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const AutoDisposeRefreshListViewWidget({
    super.key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.separatorBuilder,
    this.sliverPersistentHeader,
    this.slivers = const <Widget>[],
    this.onRetry,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.semanticChildCount,
    this.padding = EdgeInsets.zero,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.lastChildLayoutTypeBuilder,
    this.collectGarbage,
    this.viewportBuilder,
    this.closeToTrailing,
  });

  final ProviderType provider;
  final ReaderCallback? onInitState;
  final ListViewItemBuilder<T> builder;
  final ListViewSeparatorBuilder? separatorBuilder;
  final Widget? sliverPersistentHeader;
  final List<Widget> slivers;
  final ReaderCallback? onRetry;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final double? cacheExtent;
  final int? semanticChildCount;
  final EdgeInsetsGeometry padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final LastChildLayoutTypeBuilder? lastChildLayoutTypeBuilder;
  final CollectGarbage? collectGarbage;
  final ViewportBuilder? viewportBuilder;
  final bool? closeToTrailing;

  @override
  _AutoDisposeRefreshListViewWidgetState<ProviderType, T> createState() =>
      _AutoDisposeRefreshListViewWidgetState<ProviderType, T>();
}

class _AutoDisposeRefreshListViewWidgetState<
        ProviderType extends AutoDisposeStateNotifierProvider<
            BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
        T>
    extends ConsumerState<AutoDisposeRefreshListViewWidget<ProviderType, T>> {
  final ValueNotifier<LoadingMoreStatus?> _loadingMoreStatusNotifier =
      ValueNotifier<LoadingMoreStatus?>(null);

  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    _loadingMoreStatusNotifier.dispose();

    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if ((ref.read(widget.provider).whenOrNull((_, __, ___) => true) ??
              false) &&
          <LoadingMoreStatus?>[
            LoadingMoreStatus.completed,
            null,
          ].contains(_loadingMoreStatusNotifier.value)) {
        _loadingMoreStatusNotifier.value = LoadingMoreStatus.loading;
        Future<void>.delayed(Duration.zero, () async {
          _loadingMoreStatusNotifier.value =
              await ref.read(widget.provider.notifier).loadMore();
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: CustomScrollView(
        slivers: <Widget>[
          if (widget.sliverPersistentHeader != null)
            widget.sliverPersistentHeader!,
          Consumer(
            builder: (_, WidgetRef ref, Widget? empty) =>
                ref.watch(widget.provider).whenOrNull(
                      (_, __, ___) => CupertinoSliverRefreshControl(
                        onRefresh: () {
                          /// Reset [_loadingMoreStatusNotifier]
                          _loadingMoreStatusNotifier.value = null;

                          return ref.watch(widget.provider.notifier).refresh();
                        },
                      ),
                    ) ??
                empty!,
            child: const SliverToBoxAdapter(child: nil),
          ),
          ...widget.slivers,
          Consumer(
            builder: (_, WidgetRef ref, Widget? loading) => ref
                .watch(widget.provider)
                .when(
                  (int nextPageNum, bool isLastPage, List<T> list) => list
                          .isEmpty
                      ? const SliverFillRemaining(
                          child: EmptyWidget(),
                        )
                      : LoadMoreSliverList<T>(
                          list: list,
                          loadMoreIndicatorBuilder: (_) =>
                              ValueListenableBuilder<LoadingMoreStatus?>(
                            valueListenable: _loadingMoreStatusNotifier,
                            builder: (
                              BuildContext context,
                              LoadingMoreStatus? status,
                              __,
                            ) =>
                                LoadingMoreIndicator(
                              status: status,
                              onRetry: () async {
                                _loadingMoreStatusNotifier.value =
                                    LoadingMoreStatus.loading;
                                _loadingMoreStatusNotifier.value = await ref
                                    .read(widget.provider.notifier)
                                    .loadMore();
                              },
                            ),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return widget.builder
                                .call(context, ref, index, list[index]);
                          },
                          separatorBuilder: widget.separatorBuilder != null
                              ? (BuildContext context, int index) =>
                                  widget.separatorBuilder!.call(
                                    context,
                                    ref,
                                    index,
                                  )
                              : null,
                          padding: widget.padding,
                          itemExtent: widget.itemExtent,
                          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                          addRepaintBoundaries: widget.addRepaintBoundaries,
                          addSemanticIndexes: widget.addSemanticIndexes,
                          semanticIndexCallback: widget.semanticIndexCallback,
                          semanticIndexOffset: widget.semanticIndexOffset,
                          lastChildLayoutTypeBuilder:
                              widget.lastChildLayoutTypeBuilder,
                          collectGarbage: widget.collectGarbage,
                          viewportBuilder: widget.viewportBuilder,
                          closeToTrailing: widget.closeToTrailing,
                        ),
                  loading: () => loading!,
                  error: (int? statusCode, String? message, String? detail) =>
                      SliverFillRemaining(
                    child: CustomErrorWidget(
                      statusCode: statusCode,
                      message: message,
                      detail: detail,
                      onRetry: () {
                        if (widget.onRetry != null) {
                          widget.onRetry!.call(ref.read);
                        } else {
                          ref.read(widget.provider.notifier).initData();
                        }
                      },
                    ),
                  ),
                ),
            child: const SliverFillRemaining(
              child: LoadingWidget(),
            ),
          ),
        ],
        semanticChildCount: widget.semanticChildCount,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        primary: widget.primary,
        cacheExtent: widget.cacheExtent,
        controller: widget.controller,
        reverse: widget.reverse,
        dragStartBehavior: widget.dragStartBehavior,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
      ),
    );
  }
}
