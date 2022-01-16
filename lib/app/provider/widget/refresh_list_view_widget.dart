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
    this.paddingBottom,
  }) : super(key: key);

  final T provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<S> builder;

  final List<Widget>? slivers;
  final double? paddingBottom;

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
    return SmartRefresher.builder(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: () async {
        if (_refreshController.footerMode?.value == LoadStatus.noMore) {
          _refreshController.resetNoData();
        }
        final RefreshControllerStatus status =
            await ref.read(widget.provider.notifier).refresh();

        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.noData:
            _refreshController.loadNoData();
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.refreshFailed();
            break;
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
            break;
        }
      },
      builder: (_, RefreshPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            /// if [RefreshListViewState] is [RefreshListViewStateLoading],
            /// disabled enablePullDown
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<S> value) =>
                    value.whenOrNull(
                      (_, __, ___) => const DropDownListHeader(),
                      error: (_, __, ___) => const DropDownListHeader(),
                    ) ??
                    const SliverToBoxAdapter(),
              ),
            ),
            if (widget.slivers != null && widget.slivers!.isNotEmpty)
              ...widget.slivers!,
            ref.watch(widget.provider).when(
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
                      onRetry: _refreshController.requestRefresh,
                    ),
                  ),
                ),

            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullUp
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<S> value) =>
                    value.whenOrNull(
                        (_, __, ___) => const LoadMoreListFooter()) ??
                    const SliverToBoxAdapter(),
              ),
            ),
            SliverToBoxAdapter(
              child: widget.paddingBottom != null
                  ? SizedBox(
                      height: widget.paddingBottom,
                    )
                  : null,
            ),
          ],
        );
      },
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
    this.paddingBottom,
  }) : super(key: key);

  final T provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<S> builder;

  final List<Widget>? slivers;
  final double? paddingBottom;

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
    return SmartRefresher.builder(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: () async {
        if (_refreshController.footerMode?.value == LoadStatus.noMore) {
          _refreshController.resetNoData();
        }
        final RefreshControllerStatus status =
            await ref.read(widget.provider.notifier).refresh();

        switch (status) {
          case RefreshControllerStatus.completed:
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.noData:
            _refreshController.loadNoData();
            _refreshController.refreshCompleted();
            break;
          case RefreshControllerStatus.failed:
            _refreshController.refreshFailed();
            break;
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
            break;
        }
      },
      builder: (_, RefreshPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            /// if [RefreshListViewState] is [RefreshListViewStateLoading],
            /// disabled enablePullDown
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<S> value) =>
                    value.whenOrNull(
                      (_, __, ___) => const DropDownListHeader(),
                      error: (_, __, ___) => const DropDownListHeader(),
                    ) ??
                    const SliverToBoxAdapter(),
              ),
            ),
            if (widget.slivers != null && widget.slivers!.isNotEmpty)
              ...widget.slivers!,
            ref.watch(widget.provider).when(
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
                      onRetry: _refreshController.requestRefresh,
                    ),
                  ),
                ),

            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullUp
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<S> value) =>
                    value.whenOrNull(
                        (_, __, ___) => const LoadMoreListFooter()) ??
                    const SliverToBoxAdapter(),
              ),
            ),
            SliverToBoxAdapter(
              child: widget.paddingBottom != null
                  ? SizedBox(
                      height: widget.paddingBottom,
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
