part of 'provider_widget.dart';

typedef ListViewBuilder<S> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  List<S> list,
);

class ListViewWidget<
    T extends StateNotifierProvider<BaseListViewNotifier<S>, ListViewState<S>>,
    S> extends ConsumerWidget {
  const ListViewWidget({
    Key? key,
    required T model,
    required ListViewBuilder<S> builder,
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final ListViewBuilder<S> _builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(_model).when(
              (List<S> list) => list.isEmpty
                  ? const EmptyWidget()
                  : _builder(context, ref, list),
              loading: () => const LoadingWidget(),
              error: (int? statusCode, String? message, String? detail) =>
                  const CustomErrorWidget(),
            );
      },
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
  })  : _model = model,
        _builder = builder,
        super(key: key);

  final T _model;
  final ListViewBuilder<S> _builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(_model).when(
              (List<S> list) => list.isEmpty
                  ? const EmptyWidget()
                  : _builder(context, ref, list),
              loading: () => const LoadingWidget(),
              error: (int? statusCode, String? message, String? detail) =>
                  const CustomErrorWidget(),
            );
      },
    );
  }
}
