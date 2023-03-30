part of 'provider.dart';

abstract class BaseListViewNotifier<T> extends StateNotifier<ListViewState<T>> {
  @Deprecated('use (AutoDispose)AsyncNotifier<List<T>> instead.')
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
    } on Exception catch (e, s) {
      onError(e, s);

      return false;
    }
  }

  Future<List<T>> loadData();

  void onCompleted(List<T> data) {}

  @override
  ErrorListener get onError => (Object e, StackTrace? s) {
        state = ListViewState<T>.error(e, s ?? StackTrace.current);
      };
}
