part of 'provider.dart';

enum RefreshControllerStatus {
  completed,
  failed,
  noData,
}

abstract class BaseRefreshListViewNotifier<T>
    extends StateNotifier<RefreshListViewState<T>> {
  BaseRefreshListViewNotifier(
    RefreshListViewState<T> state, {
    this.initialPageNum = 0,
    this.pageSize = 20,
  }) : super(state);

  final int initialPageNum;

  final int pageSize;

  Future<void> initData() async {
    if (state != RefreshListViewState<T>.loading()) {
      state = RefreshListViewState<T>.loading();
    }
    await refresh();
  }

  Future<RefreshControllerStatus> refresh() async {
    try {
      final RefreshListViewStateData<T> data = await loadData(
        pageNum: initialPageNum,
        pageSize: pageSize,
      );

      if (data.value.isEmpty) {
        state = RefreshListViewState<T>(
          list: <T>[],
        );
      } else {
        onCompleted(data.value);

        state = RefreshListViewState<T>(
          nextPageNum: data.nextPageNum,
          list: data.value,
        );
      }

      return RefreshControllerStatus.completed;
    } catch (e, s) {
      onError(e, s);

      return RefreshControllerStatus.failed;
    }
  }

  Future<RefreshListViewStateData<T>> loadData({
    required int pageNum,
    required int pageSize,
  });

  void onCompleted(List<T> data) {}

  Future<RefreshControllerStatus?> loadMore() async {
    return await state.whenOrNull<Future<RefreshControllerStatus?>>(
      (int currentPageNum, bool isLastPage, List<T> value) async {
        try {
          final RefreshListViewStateData<T> data = await loadData(
            pageNum: currentPageNum,
            pageSize: pageSize,
          );

          onCompleted(data.value);

          state = RefreshListViewState<T>(
            nextPageNum: data.nextPageNum,
            list: <T>[
              ...value,
              ...data.value,
            ],
          );

          if (data.isLastPage) {
            return RefreshControllerStatus.noData;
          } else {
            return RefreshControllerStatus.completed;
          }
        } catch (e) {
          return RefreshControllerStatus.failed;
        }
      },
    );
  }

  @override
  ErrorListener get onError => (Object e, StackTrace? s) {
        final BaseViewStateError error = BaseViewStateError.create(e, s);

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
