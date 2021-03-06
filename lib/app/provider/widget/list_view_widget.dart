part of 'provider_widget.dart';

class ListViewWidget<
    ProviderType extends StateNotifierProvider<BaseListViewNotifier<T>,
        ListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const ListViewWidget({
    super.key,
    required this.provider,
    this.onInitState,
    this.enablePullDown = false,
    this.onRetry,
    this.builder,
    required this.itemBuilder,
    this.separatorBuilder,
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
  final bool enablePullDown;
  final ReaderCallback? onRetry;
  final ListViewWidgetBuilder? builder;
  final ListViewItemBuilder<T> itemBuilder;
  final ListViewSeparatorBuilder? separatorBuilder;
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
  _ListViewWidgetState<ProviderType, T> createState() =>
      _ListViewWidgetState<ProviderType, T>();
}

class _ListViewWidgetState<
    ProviderType extends StateNotifierProvider<BaseListViewNotifier<T>,
        ListViewState<T>>,
    T> extends ConsumerState<ListViewWidget<ProviderType, T>> {
  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enablePullDown) {
      return CustomScrollView(
        slivers: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? empty) =>
                ref.watch(widget.provider).whenOrNull(
                      (_) => CupertinoSliverRefreshControl(
                        onRefresh: ref.watch(widget.provider.notifier).refresh,
                      ),
                    ) ??
                empty!,
            child: const SliverToBoxAdapter(child: nil),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? loading) =>
                ref.watch(widget.provider).when(
              (List<T> list) {
                if (list.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget(),
                  );
                }

                Widget child = LoadMoreSliverList<T>(
                  list: list,
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
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
                  lastChildLayoutTypeBuilder: widget.lastChildLayoutTypeBuilder,
                  collectGarbage: widget.collectGarbage,
                  viewportBuilder: widget.viewportBuilder,
                  closeToTrailing: widget.closeToTrailing,
                );

                if (widget.builder != null) {
                  child = widget.builder!.call(context, child);
                }

                return child;
              },
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
      );
    }

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? loading) =>
          ref.watch(widget.provider).when(
        (List<T> list) {
          if (list.isEmpty) {
            return const EmptyWidget();
          }

          Widget child = widget.separatorBuilder != null
              ? ExtendedListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      widget.separatorBuilder!.call(
                    context,
                    ref,
                    index,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
                  extendedListDelegate: ExtendedListDelegate(
                    collectGarbage: widget.collectGarbage,
                    viewportBuilder: widget.viewportBuilder,
                    closeToTrailing: widget.closeToTrailing ?? false,
                  ),
                  itemCount: list.length,
                  scrollDirection: widget.scrollDirection,
                  reverse: widget.reverse,
                  controller: widget.controller,
                  primary: widget.primary,
                  shrinkWrap: widget.shrinkWrap,
                  padding: widget.padding,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                  cacheExtent: widget.cacheExtent,
                  dragStartBehavior: widget.dragStartBehavior,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  restorationId: widget.restorationId,
                  clipBehavior: widget.clipBehavior,
                )
              : ExtendedListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
                  extendedListDelegate: ExtendedListDelegate(
                    collectGarbage: widget.collectGarbage,
                    viewportBuilder: widget.viewportBuilder,
                    closeToTrailing: widget.closeToTrailing ?? false,
                  ),
                  itemCount: list.length,
                  scrollDirection: widget.scrollDirection,
                  reverse: widget.reverse,
                  controller: widget.controller,
                  primary: widget.primary,
                  shrinkWrap: widget.shrinkWrap,
                  padding: widget.padding,
                  itemExtent: widget.itemExtent,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                  cacheExtent: widget.cacheExtent,
                  semanticChildCount: widget.semanticChildCount,
                  dragStartBehavior: widget.dragStartBehavior,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  restorationId: widget.restorationId,
                  clipBehavior: widget.clipBehavior,
                );

          if (widget.builder != null) {
            child = widget.builder!.call(context, child);
          }

          return child;
        },
        loading: () => loading!,
        error: (int? statusCode, String? message, String? detail) =>
            CustomErrorWidget(
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
      child: const LoadingWidget(),
    );
  }
}

class AutoDisposeListViewWidget<
    ProviderType extends AutoDisposeStateNotifierProvider<
        BaseListViewNotifier<T>, ListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const AutoDisposeListViewWidget({
    super.key,
    required this.provider,
    this.onInitState,
    this.enablePullDown = false,
    this.builder,
    this.onRetry,
    required this.itemBuilder,
    this.separatorBuilder,
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
  final bool enablePullDown;
  final ListViewWidgetBuilder? builder;
  final ReaderCallback? onRetry;
  final ListViewItemBuilder<T> itemBuilder;
  final ListViewSeparatorBuilder? separatorBuilder;
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
  _AutoDisposeListViewWidgetState<ProviderType, T> createState() =>
      _AutoDisposeListViewWidgetState<ProviderType, T>();
}

class _AutoDisposeListViewWidgetState<
    ProviderType extends AutoDisposeStateNotifierProvider<
        BaseListViewNotifier<T>, ListViewState<T>>,
    T> extends ConsumerState<AutoDisposeListViewWidget<ProviderType, T>> {
  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enablePullDown) {
      return CustomScrollView(
        slivers: <Widget>[
          Consumer(
            builder: (_, WidgetRef ref, Widget? empty) =>
                ref.watch(widget.provider).whenOrNull(
                      (_) => CupertinoSliverRefreshControl(
                        onRefresh: ref.watch(widget.provider.notifier).refresh,
                      ),
                    ) ??
                empty!,
            child: const SliverToBoxAdapter(child: nil),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? loading) =>
                ref.watch(widget.provider).when(
              (List<T> list) {
                if (list.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget(),
                  );
                }

                Widget child = LoadMoreSliverList<T>(
                  list: list,
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
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
                  lastChildLayoutTypeBuilder: widget.lastChildLayoutTypeBuilder,
                  collectGarbage: widget.collectGarbage,
                  viewportBuilder: widget.viewportBuilder,
                  closeToTrailing: widget.closeToTrailing,
                );

                if (widget.builder != null) {
                  child = widget.builder!.call(context, child);
                }

                return child;
              },
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
      );
    }

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? loading) =>
          ref.watch(widget.provider).when(
        (List<T> list) {
          if (list.isEmpty) {
            return const EmptyWidget();
          }

          Widget child = widget.separatorBuilder != null
              ? ExtendedListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      widget.separatorBuilder!.call(
                    context,
                    ref,
                    index,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
                  extendedListDelegate: ExtendedListDelegate(
                    collectGarbage: widget.collectGarbage,
                    viewportBuilder: widget.viewportBuilder,
                    closeToTrailing: widget.closeToTrailing ?? false,
                  ),
                  itemCount: list.length,
                  scrollDirection: widget.scrollDirection,
                  reverse: widget.reverse,
                  controller: widget.controller,
                  primary: widget.primary,
                  shrinkWrap: widget.shrinkWrap,
                  padding: widget.padding,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                  cacheExtent: widget.cacheExtent,
                  dragStartBehavior: widget.dragStartBehavior,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  restorationId: widget.restorationId,
                  clipBehavior: widget.clipBehavior,
                )
              : ExtendedListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      widget.itemBuilder.call(context, ref, index, list[index]),
                  extendedListDelegate: ExtendedListDelegate(
                    collectGarbage: widget.collectGarbage,
                    viewportBuilder: widget.viewportBuilder,
                    closeToTrailing: widget.closeToTrailing ?? false,
                  ),
                  itemCount: list.length,
                  scrollDirection: widget.scrollDirection,
                  reverse: widget.reverse,
                  controller: widget.controller,
                  primary: widget.primary,
                  shrinkWrap: widget.shrinkWrap,
                  padding: widget.padding,
                  itemExtent: widget.itemExtent,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addSemanticIndexes: widget.addSemanticIndexes,
                  cacheExtent: widget.cacheExtent,
                  semanticChildCount: widget.semanticChildCount,
                  dragStartBehavior: widget.dragStartBehavior,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  restorationId: widget.restorationId,
                  clipBehavior: widget.clipBehavior,
                );

          if (widget.builder != null) {
            child = widget.builder!.call(context, child);
          }

          return child;
        },
        loading: () => loading!,
        error: (int? statusCode, String? message, String? detail) =>
            CustomErrorWidget(
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
      child: const LoadingWidget(),
    );
  }
}
