part of 'refresh_list_view_state_mixin.dart';

typedef OnLoadMoreCallback = Future<LoadingMoreStatus?> Function();

mixin LoadMoreMixin<T> {
  AsyncValue<PaginationData<T>> get state;
  set state(AsyncValue<PaginationData<T>> value);

  final int initialPageNum = 1;
  final int initialPageSize = 20;

  @protected
  Future<PaginationData<T>> Function(int pageNum, int pageSize) get buildMore;

  int getNextPageNum(PaginationData<T> data) =>
      (data.datas.length / data.size).ceil() + initialPageNum;

  Future<LoadingMoreStatus?> loadMore() =>
      state.whenOrNull<Future<LoadingMoreStatus?>>(
        data: (PaginationData<T> data) async {
          /// Prevents no data indicator from being displayed even when no data
          /// is available
          if (data.datas.isEmpty) {
            return null;
          }

          /// Prevent no data state not being set on initialization
          if (data.over) {
            return LoadingMoreStatus.noData;
          }

          try {
            /// Some api's pageNum will be self-increasing, some won't, so here
            /// it's handled internally.
            final int pageNum = getNextPageNum(data);

            final PaginationData<T> value = await buildMore(
              pageNum,
              initialPageSize,
            );

            state = AsyncData<PaginationData<T>>(
              value.copyWith(datas: data.datas..addAll(value.datas)),
            );

            return value.over
                ? LoadingMoreStatus.noData
                : LoadingMoreStatus.completed;
          } on Exception catch (_) {
            return LoadingMoreStatus.failed;
          }
        },
      ) ??
      Future<LoadingMoreStatus?>.value();
}
