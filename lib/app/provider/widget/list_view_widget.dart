part of 'provider_widget.dart';

typedef ListViewBuilder<S> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<S> list,
  Widget? child,
);

class ListViewWidget<
    T extends StateNotifierProvider<BaseListViewNotifier<S>, ListViewState<S>>,
    S> extends ConsumerWidget {
  const ListViewWidget({
    Key? key,
    required T model,
    required ListViewBuilder<S> builder,
    this.child,
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final ListViewBuilder<S> _builder;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final BaseListViewNotifier<S> provider = ref.read(_model.notifier);

        return ref.watch(_model).when(
              (List<S> list) => list.isEmpty
                  ? EmptyWidget(
                      onRetry: provider.initData,
                    )
                  : provider.enablePullDown
                      ? SmartRefresher(
                          enablePullDown: true,
                          header: const DropDownListHeader(),
                          controller: provider.refreshController,
                          onRefresh: provider.refresh,
                          child: list.isEmpty
                              ? EmptyWidget(
                                  onRetry: provider.refresh,
                                )
                              : _builder(context, ref, list, child),
                        )
                      : _builder(context, ref, list, child),
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

class AutoDisposeListViewWidget<
    T extends AutoDisposeStateNotifierProvider<BaseListViewNotifier<S>,
        ListViewState<S>>,
    S> extends ConsumerWidget {
  const AutoDisposeListViewWidget({
    Key? key,
    required T model,
    required ListViewBuilder<S> builder,
    this.child,
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final ListViewBuilder<S> _builder;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BaseListViewNotifier<S> provider = ref.read(_model.notifier);

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(_model).when(
              (List<S> list) => list.isEmpty
                  ? EmptyWidget(
                      onRetry: provider.initData,
                    )
                  : provider.enablePullDown
                      ? SmartRefresher(
                          enablePullDown: true,
                          header: const DropDownListHeader(),
                          controller: provider.refreshController,
                          onRefresh: provider.refresh,
                          child: list.isEmpty
                              ? EmptyWidget(
                                  onRetry: provider.refresh,
                                )
                              : _builder(context, ref, list, child),
                        )
                      : _builder(context, ref, list, child),
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
