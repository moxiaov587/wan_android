part of 'provider_widget.dart';

typedef ListViewBuilder<T> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<T> list,
);

class ListViewWidget<
    ProviderType extends StateNotifierProvider<BaseListViewNotifier<T>,
        ListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const ListViewWidget({
    super.key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.enablePullDown = false,
    this.slivers,
    this.onRetry,
  });

  final ProviderType provider;
  final ReaderCallback? onInitState;
  final ListViewBuilder<T> builder;
  final bool enablePullDown;

  final List<Widget>? slivers;
  final ReaderCallback? onRetry;

  @override
  _ListViewWidgetState<ProviderType, T> createState() =>
      _ListViewWidgetState<ProviderType, T>();
}

class _ListViewWidgetState<
    ProviderType extends StateNotifierProvider<BaseListViewNotifier<T>,
        ListViewState<T>>,
    T> extends ConsumerState<ListViewWidget<ProviderType, T>> {
  late final RefreshController _refreshController;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    if (widget.enablePullDown) {
      _refreshController = RefreshController();
    } else {
      _scrollController = ScrollController();
    }

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    if (widget.enablePullDown) {
      _refreshController.dispose();
    } else {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enablePullDown
        ? SmartRefresher.builder(
            controller: _refreshController,
            onRefresh: () async {
              final RefreshControllerStatus? status =
                  await ref.read(widget.provider.notifier).refresh();
              switch (status) {
                case RefreshControllerStatus.noData:
                case null:
                  // [status] is null
                  break;
                case RefreshControllerStatus.completed:
                  _refreshController.refreshCompleted();
                  break;
                case RefreshControllerStatus.failed:
                  _refreshController.refreshFailed();
                  break;
              }
            },
            builder: (_, RefreshPhysics physics) {
              return CustomScrollView(
                physics: physics,
                slivers: <Widget>[
                  /// if [RefreshListViewState] is [RefreshListViewStateLoading]
                  /// or [RefreshListViewStateError], disabled enablePullDown
                  ref.watch(
                    widget.provider.select(
                      (ListViewState<T> value) =>
                          value.whenOrNull(
                            (_) => const DropDownListHeader(),
                          ) ??
                          const SliverToBoxAdapter(),
                    ),
                  ),
                  if (widget.slivers != null && widget.slivers!.isNotEmpty)
                    ...widget.slivers!,
                  ref.watch(widget.provider).when(
                        (List<T> list) => list.isEmpty
                            ? const SliverFillRemaining(
                                child: EmptyWidget(),
                              )
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (
                          int? statusCode,
                          String? message,
                          String? detail,
                        ) =>
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
                ],
              );
            },
          )
        : CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              if (widget.slivers != null && widget.slivers!.isNotEmpty)
                ...widget.slivers!
              else
                const SliverToBoxAdapter(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ref.watch(widget.provider).when(
                        (List<T> list) => list.isEmpty
                            ? const SliverFillRemaining(
                                child: EmptyWidget(),
                              )
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (
                          int? statusCode,
                          String? message,
                          String? detail,
                        ) =>
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
                      );
                },
              ),
            ],
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
    required this.builder,
    this.enablePullDown = false,
    this.slivers,
    this.onRetry,
  });

  final ProviderType provider;
  final ReaderCallback? onInitState;
  final ListViewBuilder<T> builder;
  final bool enablePullDown;

  final List<Widget>? slivers;
  final ReaderCallback? onRetry;

  @override
  _AutoDisposeListViewWidgetState<ProviderType, T> createState() =>
      _AutoDisposeListViewWidgetState<ProviderType, T>();
}

class _AutoDisposeListViewWidgetState<
    ProviderType extends AutoDisposeStateNotifierProvider<
        BaseListViewNotifier<T>, ListViewState<T>>,
    T> extends ConsumerState<AutoDisposeListViewWidget<ProviderType, T>> {
  late final RefreshController _refreshController;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    if (widget.enablePullDown) {
      _refreshController = RefreshController();
    } else {
      _scrollController = ScrollController();
    }

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    if (widget.enablePullDown) {
      _refreshController.dispose();
    } else {
      _scrollController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enablePullDown
        ? SmartRefresher.builder(
            controller: _refreshController,
            onRefresh: () async {
              final RefreshControllerStatus? status =
                  await ref.read(widget.provider.notifier).refresh();
              switch (status) {
                case null:
                case RefreshControllerStatus.noData:
                  // [status] is null
                  break;
                case RefreshControllerStatus.completed:
                  _refreshController.refreshCompleted();
                  break;
                case RefreshControllerStatus.failed:
                  _refreshController.refreshFailed();
                  break;
              }
            },
            builder: (_, RefreshPhysics physics) {
              return CustomScrollView(
                physics: physics,
                slivers: <Widget>[
                  /// if [RefreshListViewState] is [RefreshListViewStateLoading]
                  /// or [RefreshListViewStateError], disabled enablePullDown
                  ref.watch(
                    widget.provider.select(
                      (ListViewState<T> value) =>
                          value.whenOrNull(
                            (_) => const DropDownListHeader(),
                          ) ??
                          const SliverToBoxAdapter(),
                    ),
                  ),
                  if (widget.slivers != null && widget.slivers!.isNotEmpty)
                    ...widget.slivers!,
                  ref.watch(widget.provider).when(
                        (List<T> list) => list.isEmpty
                            ? const SliverFillRemaining(
                                child: EmptyWidget(),
                              )
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (
                          int? statusCode,
                          String? message,
                          String? detail,
                        ) =>
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
                ],
              );
            },
          )
        : CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              if (widget.slivers != null && widget.slivers!.isNotEmpty)
                ...widget.slivers!
              else
                const SliverToBoxAdapter(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ref.watch(widget.provider).when(
                        (List<T> list) => list.isEmpty
                            ? const SliverFillRemaining(
                                child: EmptyWidget(),
                              )
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (
                          int? statusCode,
                          String? message,
                          String? detail,
                        ) =>
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
                      );
                },
              ),
            ],
          );
  }
}
