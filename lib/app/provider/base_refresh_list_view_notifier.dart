part of 'provider.dart';

abstract class BaseRefreshListViewNotifier<T>
    extends StateNotifier<RefreshListViewState<T>> {
  BaseRefreshListViewNotifier(
    RefreshListViewState<T> state, {
    int initialPageNum = 0,
    int pageSize = 20,
  })  : _initialPageNum = initialPageNum,
        _pageSize = pageSize,
        super(state) {
    initData();
  }

  final int _initialPageNum;

  final int _pageSize;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  Future<void> initData() async {
    if (state != RefreshListViewState<T>.loading()) {
      state = RefreshListViewState<T>.loading();
    }
    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    try {
      if (!init && !_refreshController.isRefresh) {
        _refreshController.requestRefresh();
      }

      final RefreshListViewStateData<T> data = await loadData(
        pageNum: _initialPageNum,
        pageSize: _pageSize,
      );

      if (data.value.isEmpty) {
        state = RefreshListViewState<T>(
          value: <T>[],
        );
      } else {
        onCompleted(data.value);

        state = RefreshListViewState<T>(
          nextPageNum: data.nextPageNum,
          value: data.value,
        );
      }

      if (!init) {
        _refreshController.refreshCompleted();
      }
    } catch (e, s) {
      onError(e, s);

      if (!init) {
        _refreshController.refreshFailed();
      }
    }
  }

  Future<RefreshListViewStateData<T>> loadData({
    required int pageNum,
    required int pageSize,
  });

  void onCompleted(List<T> data) {}

  Future<void> loadMore() async {
    state.when(
      (int currentPageNum, bool isLastPage, List<T> value) async {
        try {
          final RefreshListViewStateData<T> data = await loadData(
            pageNum: currentPageNum,
            pageSize: _pageSize,
          );

          if (data.isLastPage) {
            _refreshController.loadNoData();
          } else {
            onCompleted(data.value);

            state = RefreshListViewState<T>(
              nextPageNum: data.nextPageNum,
              value: <T>[
                ...value,
                ...data.value,
              ],
            );

            _refreshController.loadComplete();
          }
        } catch (e) {
          _refreshController.loadFailed();
        }
      },
      loading: () {},
      error: (
        _,
        __,
        ___,
      ) {},
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
