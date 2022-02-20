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
    this.initialPageNum = 1,
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

      onCompleted(data.list);

      state = RefreshListViewState<T>(
        pageNum: data.pageNum,
        isLastPage: data.isLastPage,
        list: data.list,
      );

      if (data.isLastPage) {
        return RefreshControllerStatus.noData;
      } else {
        return RefreshControllerStatus.completed;
      }
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
      (int pageNum, bool isLastPage, List<T> list) async {
        try {
          /// Prevent no data state not being set on initialization
          if (isLastPage) {
            return RefreshControllerStatus.noData;
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
        final BaseViewStateError error = getError(e, s);

        setError(
          statusCode: error.statusCode,
          message: error.message,
          detail: error.detail,
        );
      };

  BaseViewStateError Function(Object e, StackTrace? s) get getError =>
      (Object e, StackTrace? s) => BaseViewStateError.create(e, s);

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
