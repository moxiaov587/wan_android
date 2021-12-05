part of 'provider.dart';

abstract class BaseViewNotifier<T> extends StateNotifier<ViewState<T>> {
  BaseViewNotifier(ViewState<T> state) : super(state);

  Future<void> initData() async {
    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    try {
      final T? data = await loadData();

      onCompleted(data);

      state = ViewState<T>(
        value: data,
      );
    } catch (e, s) {
      onError(e, s);
    }
  }

  Future<T?> loadData();

  void onCompleted(T? data) {}

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
    state = ViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
