part of 'provider_widget.dart';

typedef ListViewBuilder<S> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<S> list,
);

class ListViewWidget<
    T extends StateNotifierProvider<BaseListViewNotifier<S>, ListViewState<S>>,
    S> extends ConsumerStatefulWidget {
  const ListViewWidget({
    Key? key,
    required this.provider,
    this.onInitState,
    required this.builder,
    this.enablePullDown = false,
    this.slivers,
  }) : super(key: key);

  final T provider;
  final ReaderCallback? onInitState;
  final ListViewBuilder<S> builder;
  final bool enablePullDown;

  final List<Widget>? slivers;

  @override
  _ListViewWidgetState<T, S> createState() => _ListViewWidgetState<T, S>();
}

class _ListViewWidgetState<
    T extends StateNotifierProvider<BaseListViewNotifier<S>, ListViewState<S>>,
    S> extends ConsumerState<ListViewWidget<T, S>> {
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
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: () async {
              final RefreshControllerStatus? status =
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
            builder: (_, RefreshPhysics physics) {
              return CustomScrollView(
                physics: physics,
                slivers: <Widget>[
                  /// if [RefreshListViewState] is [RefreshListViewStateLoading],
                  /// disabled enablePullDown
                  ref.watch(
                    widget.provider.select(
                      (ListViewState<S> value) =>
                          value.whenOrNull(
                            (_) => const DropDownListHeader(),
                            error: (_, __, ___) => const DropDownListHeader(),
                          ) ??
                          const SliverToBoxAdapter(),
                    ),
                  ),
                  if (widget.slivers != null && widget.slivers!.isNotEmpty)
                    ...widget.slivers!,
                  ref.watch(widget.provider).when(
                        (List<S> list) => list.isEmpty
                            ? const EmptyWidget()
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (int? statusCode, String? message,
                                String? detail) =>
                            SliverFillRemaining(
                          child: CustomErrorWidget(
                            statusCode: statusCode,
                            message: message,
                            detail: detail,
                            onRetry: _refreshController.requestRefresh,
                          ),
                        ),
                      )
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
                        (List<S> list) => list.isEmpty
                            ? const EmptyWidget()
                            : widget.builder(context, ref, list),
                        loading: () => const SliverFillRemaining(
                          child: LoadingWidget(),
                        ),
                        error: (int? statusCode, String? message,
                                String? detail) =>
                            SliverFillRemaining(
                          child: CustomErrorWidget(
                            statusCode: statusCode,
                            message: message,
                            detail: detail,
                            onRetry: () {
                              ref.read(widget.provider.notifier).initData();
                            },
                          ),
                        ),
                      );
                },
              )
            ],
          );
  }
}
