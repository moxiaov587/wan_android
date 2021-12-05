part of 'provider.dart';

abstract class BaseRefreshListViewNotifier<T>
    extends StateNotifier<RefreshListViewState<T>> {
  BaseRefreshListViewNotifier(RefreshListViewState<T> state) : super(state) {
    initData();
  }

  static const int initPageNum = 1;

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

      final List<T>? data = await loadData(
        pageNum: initPageNum,
      );

      if (data == null || data.isEmpty) {
        state = RefreshListViewState<T>(
          value: <T>[],
        );
      } else {
        onCompleted(data);

        state = RefreshListViewState<T>(
          pageNum: initPageNum,
          value: data,
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

  Future<List<T>?> loadData({int? pageNum});

  void onCompleted(List<T> data) {}

  Future<void> loadMore() async {
    state.when(
      (int pageNum, List<T> value) async {
        try {
          final List<T>? data = await loadData(
            pageNum: pageNum + 1,
          );

          if (data == null || data.isEmpty) {
            _refreshController.loadNoData();
          } else {
            onCompleted(data);

            state = RefreshListViewState<T>(
              pageNum: pageNum + 1,
              value: <T>[
                ...value,
                ...data,
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
