part of 'provider.dart';

abstract class BaseListViewNotifier<T> extends StateNotifier<ListViewState<T>>
    with ViewErrorMixin {
  BaseListViewNotifier(super.state);

  Future<bool> initData() async {
    if (state != ListViewState<T>.loading()) {
      state = ListViewState<T>.loading();
    }

    return refresh();
  }

  Future<bool> refresh() async {
    try {
      final List<T> data = await loadData();

      onCompleted(data);

      state = ListViewState<T>(
        list: data,
      );

      return true;
    } catch (e, s) {
      onError(e, s);

      return false;
    }
  }

  Future<List<T>> loadData();

  void onCompleted(List<T> data) {}

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
    state = ListViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
