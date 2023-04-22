part of 'refresh_list_view_state_mixin.dart';

const int kDefaultPageNum = 1;
const int kDefaultPageSize = 20;

mixin LoadMoreMixin<T> {
  AsyncValue<PaginationData<T>> get state;
  set state(AsyncValue<PaginationData<T>> value);
  late final int pageNum;
  late final int pageSize;

  @protected
  Future<PaginationData<T>> buildMore(int pageNum, int pageSize);

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

            final PaginationData<T> value = await buildMore(
              data.curPage + 1,
              pageSize,
            );

            state = AsyncData<PaginationData<T>>(
              value.copyWith(
                curPage: data.curPage + 1,
                datas: data.datas..addAll(value.datas),
              ),
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
