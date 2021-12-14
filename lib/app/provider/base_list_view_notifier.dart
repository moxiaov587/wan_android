part of 'provider.dart';

abstract class BaseListViewNotifier<T> extends StateNotifier<ListViewState<T>> {
  BaseListViewNotifier(
    ListViewState<T> state, {
    bool enablePullDown = true,
  })  : _enablePullDown = enablePullDown,
        super(state) {
    initData();
  }

  final bool _enablePullDown;

  bool get enablePullDown => _enablePullDown;

  late final RefreshController _refreshController;

  RefreshController get refreshController => _refreshController;

  Future<void> initData() async {
    if (state != ListViewState<T>.loading()) {
      state = ListViewState<T>.loading();
    }

    if (_enablePullDown) {
      _refreshController = RefreshController();
    }

    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    try {
      if (_enablePullDown && !init && !_refreshController.isRefresh) {
        _refreshController.requestRefresh();
      }

      final List<T> data = await loadData();

      if (data.isEmpty) {
        state = ListViewState<T>(
          list: <T>[],
        );
      } else {
        onCompleted(data);

        state = ListViewState<T>(
          list: data,
        );

        if (_enablePullDown && !init) {
          _refreshController.refreshCompleted();
        }
      }
    } catch (e, s) {
      onError(e, s);

      if (_enablePullDown && !init) {
        _refreshController.refreshFailed();
      }
    }
  }

  Future<List<T>> loadData();

  void onCompleted(List<T> data) {}

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
    state = ListViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }

  @override
  void dispose() {
    if (_enablePullDown) {
      _refreshController.dispose();
    }

    super.dispose();
  }
}
