part of 'provider_widget.dart';

typedef ReaderCallback = void Function(Reader reader);

typedef RefreshListViewBuilder<T> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<T> list,
);

class RefreshListViewWidget<
    ProviderType extends StateNotifierProvider<BaseRefreshListViewNotifier<T>,
        RefreshListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const RefreshListViewWidget({
    Key? key,
    this.paddingVertical,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.slivers,
    this.onRetry,
  }) : super(key: key);

  final EdgeInsets? paddingVertical;
  final ProviderType provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<T> builder;

  final List<Widget>? slivers;
  final ReaderCallback? onRetry;

  @override
  _RefreshListViewWidgetState<ProviderType, T> createState() =>
      _RefreshListViewWidgetState<ProviderType, T>();
}

class _RefreshListViewWidgetState<
    ProviderType extends StateNotifierProvider<BaseRefreshListViewNotifier<T>,
        RefreshListViewState<T>>,
    T> extends ConsumerState<RefreshListViewWidget<ProviderType, T>> {
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
        final List<Widget>? headerSlivers = widget.slivers;

        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullDown
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<T> value) =>
                    value.whenOrNull(
                      (_, __, ___) => DropDownListHeader(
                        marginTop: widget.paddingVertical?.top,
                      ),
                    ) ??
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: widget.paddingVertical?.top ?? 0.0,
                      ),
                    ),
              ),
            ),
            if (headerSlivers != null && headerSlivers.isNotEmpty)
              ...headerSlivers,
            ref.watch(widget.provider).when(
                  (int nextPageNum, bool isLastPage, List<T> list) =>
                      list.isEmpty
                          ? const SliverFillRemaining(
                              child: EmptyWidget(),
                            )
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

            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullUp
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<T> value) =>
                    value.whenOrNull(
                      (_, __, ___) => LoadMoreListFooter(
                        marginBottom: widget.paddingVertical?.bottom,
                      ),
                    ) ??
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: widget.paddingVertical?.bottom ?? 0.0,
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AutoDisposeRefreshListViewWidget<
    ProviderType extends AutoDisposeStateNotifierProvider<
        BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
    T> extends ConsumerStatefulWidget {
  const AutoDisposeRefreshListViewWidget({
    Key? key,
    this.paddingVertical,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.slivers,
    this.onRetry,
  }) : super(key: key);

  final EdgeInsets? paddingVertical;
  final ProviderType provider;
  final ReaderCallback? onInitState;
  final RefreshListViewBuilder<T> builder;

  final List<Widget>? slivers;
  final ReaderCallback? onRetry;

  @override
  _AutoDisposeRefreshListViewWidgetState<ProviderType, T> createState() =>
      _AutoDisposeRefreshListViewWidgetState<ProviderType, T>();
}

class _AutoDisposeRefreshListViewWidgetState<
        ProviderType extends AutoDisposeStateNotifierProvider<
            BaseRefreshListViewNotifier<T>, RefreshListViewState<T>>,
        T>
    extends ConsumerState<AutoDisposeRefreshListViewWidget<ProviderType, T>> {
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
        final List<Widget>? headerSlivers = widget.slivers;

        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullDown
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<T> value) =>
                    value.whenOrNull(
                      (_, __, ___) => DropDownListHeader(
                        marginTop: widget.paddingVertical?.top,
                      ),
                    ) ??
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: widget.paddingVertical?.top ?? 0.0,
                      ),
                    ),
              ),
            ),
            if (headerSlivers != null && headerSlivers.isNotEmpty)
              ...headerSlivers,
            ref.watch(widget.provider).when(
                  (int nextPageNum, bool isLastPage, List<T> list) =>
                      list.isEmpty
                          ? const SliverFillRemaining(
                              child: EmptyWidget(),
                            )
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

            /// if [RefreshListViewState] is [RefreshListViewStateLoading] or
            /// [RefreshListViewStateError], disabled enablePullUp
            ref.watch(
              widget.provider.select(
                (RefreshListViewState<T> value) =>
                    value.whenOrNull(
                      (_, __, ___) => LoadMoreListFooter(
                        marginBottom: widget.paddingVertical?.bottom,
                      ),
                    ) ??
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: widget.paddingVertical?.bottom ?? 0.0,
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
