part of 'provider.dart';

abstract class BaseListViewNotifier<T> extends StateNotifier<ListViewState<T>> {
  BaseListViewNotifier(ListViewState<T> state) : super(state);

  Future<void> initData() async {
    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    try {
      final List<T>? data = await loadData();

      if (data == null || data.isEmpty) {
        state = ListViewState<T>(
          value: <T>[],
        );
      } else {
        onCompleted(data);

        state = ListViewState<T>(
          value: data,
        );
      }
    } catch (e, s) {
      onError(e, s);
    }
  }

  Future<List<T>?> loadData();

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
}
