part of 'provider_widget.dart';

typedef RefreshListViewBuilder<S> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<S> list,
  Widget? child,
);

class RefreshListViewWidget<
    T extends StateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerWidget {
  const RefreshListViewWidget({
    Key? key,
    required T model,
    required RefreshListViewBuilder<S> builder,
    this.child,
    this.footerBottomMargin = 0.0,
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final RefreshListViewBuilder<S> _builder;
  final Widget? child;

  final double footerBottomMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final BaseRefreshListViewNotifier<S> provider =
            ref.read(_model.notifier);

        return ref.watch(_model).when(
              (_, __, List<S> list) => SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: const DropDownListHeader(),
                footer: LoadMoreListFooter(
                  marginBottom: footerBottomMargin,
                ),
                controller: provider.refreshController,
                onRefresh: provider.refresh,
                onLoading: provider.loadMore,
                child: list.isEmpty
                    ? EmptyWidget(
                        onRetry: provider.refresh,
                      )
                    : _builder(context, ref, list, child),
              ),
              loading: () => const LoadingWidget(),
              error: (int? statusCode, String? message, String? detail) =>
                  CustomErrorWidget(
                statusCode: statusCode,
                message: message,
                detail: detail,
                onRetry: provider.refresh,
              ),
            );
      },
      child: child,
    );
  }
}

class AutoDisposeRefreshListViewWidget<
    T extends AutoDisposeStateNotifierProvider<BaseRefreshListViewNotifier<S>,
        RefreshListViewState<S>>,
    S> extends ConsumerWidget {
  const AutoDisposeRefreshListViewWidget({
    Key? key,
    required T model,
    required RefreshListViewBuilder<S> builder,
    this.child,
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final RefreshListViewBuilder<S> _builder;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final BaseRefreshListViewNotifier<S> provider =
            ref.read(_model.notifier);

        return ref.watch(_model).when(
              (_, __, List<S> list) => SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: const DropDownListHeader(),
                controller: provider.refreshController,
                onRefresh: provider.refresh,
                onLoading: provider.loadMore,
                child: list.isEmpty
                    ? EmptyWidget(
                        onRetry: provider.refresh,
                      )
                    : _builder(context, ref, list, child),
              ),
              loading: () => const LoadingWidget(),
              error: (int? statusCode, String? message, String? detail) =>
                  CustomErrorWidget(
                statusCode: statusCode,
                message: message,
                detail: detail,
                onRetry: provider.refresh,
              ),
            );
      },
      child: child,
    );
  }
}
