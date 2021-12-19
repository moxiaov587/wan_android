part of 'provider_widget.dart';

typedef ReaderCallback = void Function(Reader reader);

typedef RefreshListViewBuilder<S> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<S> list,
);

class RefreshListViewWidget<
    T extends StateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerStatefulWidget {
  const RefreshListViewWidget({
    Key? key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.slivers,
  }) : super(key: key);

  final T provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<S> builder;

  final List<Widget>? slivers;

  @override
  _RefreshListViewWidgetState<T, S> createState() =>
      _RefreshListViewWidgetState<T, S>();
}

class _RefreshListViewWidgetState<
    T extends StateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerState<RefreshListViewWidget<T, S>> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// if [RefreshListViewState] is [RefreshListViewStateLoading],
    /// disabled enablePullDown
    final bool enablePullDown = ref.watch(
      widget.provider.select((RefreshListViewState<S> value) =>
          value.whenOrNull(
            (_, __, ___) => true,
            error: (_, __, ___) => true,
          ) ??
          false),
    );

    /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
    /// [RefreshListViewStateError], disabled enablePullUp
    final bool enablePullUp = ref.watch(
      widget.provider.select((RefreshListViewState<S> value) =>
          value.whenOrNull((_, __, ___) => true) ?? false),
    );

    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: const DropDownListHeader(),
      footer: const LoadMoreListFooter(),
      controller: _refreshController,
      onRefresh: () async {
        final RefreshControllerStatus status =
            await ref.read(widget.provider.notifier).refresh();
        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.refreshFailed();
            break;
          default:

          /// [status] is null
        }
      },
      onLoading: () async {
        final RefreshControllerStatus? status =
            await ref.read(widget.provider.notifier).loadMore();
        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.loadComplete();
            break;
          case RefreshControllerStatus.noData:
            _refreshController.loadNoData();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.loadFailed();
            break;
          default:

          /// [status] is null
        }
      },
      child: CustomScrollView(
        slivers: <Widget>[
          if (widget.slivers != null && widget.slivers!.isNotEmpty)
            ...widget.slivers!,
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return ref.watch(widget.provider).when(
                    (int nextPageNum, bool isLastPage, List<S> list) =>
                        list.isEmpty
                            ? const EmptyWidget()
                            : widget.builder(context, ref, list),
                    loading: () => const SliverFillRemaining(
                      child: LoadingWidget(),
                    ),
                    error: (int? statusCode, String? message, String? detail) =>
                        SliverFillRemaining(
                      child: CustomErrorWidget(
                        statusCode: statusCode,
                        message: message,
                        detail: detail,
                        onRetry: () async {
                          _refreshController.requestRefresh();

                          final RefreshControllerStatus status = await ref
                              .read(widget.provider.notifier)
                              .refresh();
                          switch (status) {
                            case RefreshControllerStatus.completed:
                              _refreshController.refreshCompleted();
                              break;
                            case RefreshControllerStatus.failed:
                              _refreshController.refreshFailed();
                              break;
                            default:

                            /// [status] is null
                          }
                        },
                      ),
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}

class AutoDisposeRefreshListViewWidget<
    T extends AutoDisposeStateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerStatefulWidget {
  const AutoDisposeRefreshListViewWidget({
    Key? key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.slivers,
  }) : super(key: key);

  final T provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<S> builder;

  final List<Widget>? slivers;

  @override
  _AutoDisposeRefreshListViewWidgetState<T, S> createState() =>
      _AutoDisposeRefreshListViewWidgetState<T, S>();
}

class _AutoDisposeRefreshListViewWidgetState<
    T extends AutoDisposeStateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerState<AutoDisposeRefreshListViewWidget<T, S>> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    widget.onInitState?.call(ref.read);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// if [RefreshListViewState] is [RefreshListViewStateLoading],
    /// disabled enablePullDown
    final bool enablePullDown = ref.watch(
      widget.provider.select((RefreshListViewState<S> value) =>
          value.whenOrNull(
            (_, __, ___) => true,
            error: (_, __, ___) => true,
          ) ??
          false),
    );

    /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
    /// [RefreshListViewStateError], disabled enablePullUp
    final bool enablePullUp = ref.watch(
      widget.provider.select((RefreshListViewState<S> value) =>
          value.whenOrNull((_, __, ___) => true) ?? false),
    );

    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: const DropDownListHeader(),
      footer: const LoadMoreListFooter(),
      controller: _refreshController,
      onRefresh: () async {
        final RefreshControllerStatus status =
            await ref.read(widget.provider.notifier).refresh();
        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.refreshFailed();
            break;
          default:

          /// [status] is null
        }
      },
      onLoading: () async {
        final RefreshControllerStatus? status =
            await ref.read(widget.provider.notifier).loadMore();
        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.loadComplete();
            break;
          case RefreshControllerStatus.noData:
            _refreshController.loadNoData();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.loadFailed();
            break;
          default:

          /// [status] is null
        }
      },
      child: CustomScrollView(
        slivers: <Widget>[
          if (widget.slivers != null && widget.slivers!.isNotEmpty)
            ...widget.slivers!,
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return ref.watch(widget.provider).when(
                    (int nextPageNum, bool isLastPage, List<S> list) =>
                        list.isEmpty
                            ? const EmptyWidget()
                            : widget.builder(context, ref, list),
                    loading: () => const SliverFillRemaining(
                      child: LoadingWidget(),
                    ),
                    error: (int? statusCode, String? message, String? detail) =>
                        SliverFillRemaining(
                      child: CustomErrorWidget(
                        statusCode: statusCode,
                        message: message,
                        detail: detail,
                        onRetry: () async {
                          _refreshController.requestRefresh();

                          final RefreshControllerStatus status = await ref
                              .read(widget.provider.notifier)
                              .refresh();
                          switch (status) {
                            case RefreshControllerStatus.completed:
                              _refreshController.refreshCompleted();
                              break;
                            case RefreshControllerStatus.failed:
                              _refreshController.refreshFailed();
                              break;
                            default:

                            /// [status] is null
                          }
                        },
                      ),
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}
