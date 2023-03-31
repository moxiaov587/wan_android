import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart' show nil;
import 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

import '../../../widget/view_state_widget.dart';
import '../../http/interceptors/interceptors.dart';

export 'package:riverpod_annotation/riverpod_annotation.dart' show FutureOr;

mixin ListViewStateMixin<ProviderType extends ProviderBase<AsyncValue<List<T>>>,
        T, ConsumerStatefulWidgetType extends ConsumerStatefulWidget>
    on ConsumerState<ConsumerStatefulWidgetType> {
  @protected
  ProviderType get provider;

  @protected
  Refreshable<Future<List<T>>> get refreshable;

  Widget get pullDownIndicator => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) =>
            ref.watch(provider).whenOrNull(
                  data: (_) => CupertinoSliverRefreshControl(
                    onRefresh: () async => ref.refresh(refreshable),
                  ),
                ) ??
            const SliverToBoxAdapter(child: nil),
      );

  FutureOr<void> onRetry() {
    ref.invalidate(provider);
  }

  Widget loadingIndicatorBuilder() => const SliverFillRemaining(
        child: LoadingWidget.listView(),
      );

  Widget errorIndicatorBuilder(Object e, StackTrace s) => SliverFillRemaining(
        child: CustomErrorWidget.withAppException(
          AppException.create(e, s),
          onRetry: onRetry,
        ),
      );
}
