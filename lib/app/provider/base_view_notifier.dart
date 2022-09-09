part of 'provider.dart';

abstract class BaseViewNotifier<T> extends StateNotifier<ViewState<T>>
    with ViewErrorMixin {
  BaseViewNotifier(super.state);

  Future<bool> initData() async {
    if (state != ViewState<T>.loading()) {
      state = ViewState<T>.loading();
    }

    return refresh();
  }

  Future<bool> refresh() async {
    try {
      final T? data = await loadData();

      onCompleted(data);

      state = ViewState<T>(
        value: data,
      );

      return true;
    } catch (e, s) {
      onError(e, s);

      return false;
    }
  }

  Future<T?> loadData();

  void onCompleted(T? data) {}

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
    state = ViewState<T>.error(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}
