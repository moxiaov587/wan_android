part of 'provider.dart';

abstract class BaseListViewNotifier<T> extends StateNotifier<ListViewState<T>> {
  BaseListViewNotifier(ListViewState<T> state) : super(state);

  Future<void> initData() async {
    if (state != ListViewState<T>.loading()) {
      state = ListViewState<T>.loading();
    }

    await refresh();
  }

  Future<RefreshControllerStatus?> refresh() async {
    try {
      final List<T> data = await loadData();

      onCompleted(data);

      state = ListViewState<T>(
        list: data,
      );

      return RefreshControllerStatus.completed;
    } catch (e, s) {
      onError(e, s);

      return RefreshControllerStatus.failed;
    }
  }

  Future<List<T>> loadData();

  void onCompleted(List<T> data) {}

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
    state = ListViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
