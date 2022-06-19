part of 'provider.dart';

abstract class BaseRefreshListViewNotifier<T>
    extends StateNotifier<RefreshListViewState<T>> with ViewErrorMixin {
  BaseRefreshListViewNotifier(
    super.state, {
    this.initialPageNum = 1,
    this.pageSize = 20,
  });

  final int initialPageNum;

  final int pageSize;

  Future<void> initData() async {
    if (state != RefreshListViewState<T>.loading()) {
      state = RefreshListViewState<T>.loading();
    }
    await refresh();
  }

  Future<bool> refresh() async {
    try {
      final RefreshListViewStateData<T> data = await loadData(
        pageNum: initialPageNum,
        pageSize: pageSize,
      );

      onCompleted(data.list);

      state = RefreshListViewState<T>(
        pageNum: data.pageNum,
        isLastPage: data.isLastPage,
        list: data.list,
      );

      return true;
    } catch (e, s) {
      onError(e, s);

      return false;
    }
  }

  Future<RefreshListViewStateData<T>> loadData({
    required int pageNum,
    required int pageSize,
  });

  void onCompleted(List<T> data) {}

  Future<LoadingMoreStatus?> loadMore() {
    return state.whenOrNull<Future<LoadingMoreStatus?>>(
          (int pageNum, bool isLastPage, List<T> list) async {
            try {
              /// Prevent no data state not being set on initialization
              if (isLastPage) {
                return LoadingMoreStatus.noData;
              }

              final RefreshListViewStateData<T> data = await loadData(
                pageNum: pageNum + 1,
                pageSize: pageSize,
              );

              onCompleted(data.list);

              state = RefreshListViewState<T>(
                pageNum: data.pageNum,
                isLastPage: data.isLastPage,
                list: <T>[
                  ...list,
                  ...data.list,
                ],
              );

              return data.isLastPage
                  ? LoadingMoreStatus.noData
                  : LoadingMoreStatus.completed;
            } catch (e) {
              return LoadingMoreStatus.failed;
            }
          },
        ) ??
        Future<LoadingMoreStatus?>.value();
  }

  @override
  ErrorListener get onError => (Object e, StackTrace? s) {
        final ViewError error = getError(e, s);

        setError(
          statusCode: error.statusCode,
          message: error.message,
          detail: error.detail,
        );
      };

  void setError({
    int? statusCode,
    String? message,
    String? detail,
  }) {
    state = RefreshListViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}

enum LoadingMoreStatus {
  loading,
  completed,
  noData,
  failed,
}
