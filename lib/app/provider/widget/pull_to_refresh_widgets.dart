import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:nil/nil.dart';

import '../../../contacts/icon_font_icons.dart';
import '../../../widget/gap.dart';
import '../../l10n/generated/l10n.dart';
import '../provider.dart';

class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({
    super.key,
    required this.status,
    required this.onRetry,
  });

  final LoadingMoreStatus status;

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (<LoadingMoreStatus?>[null, LoadingMoreStatus.completed]
        .contains(status)) {
      return nil;
    }

    Widget? icon;

    String? tips;

    switch (status) {
      case LoadingMoreStatus.completed:
        break;
      case LoadingMoreStatus.loading:
        icon = const SizedBox(
          width: 25.0,
          height: 25.0,
          child: CupertinoActivityIndicator(),
        );
        tips = S.of(context).loadingMore;
        break;
      case LoadingMoreStatus.noData:
        tips = S.of(context).noMore;
        break;
      case LoadingMoreStatus.failed:
        icon = const Icon(IconFontIcons.errorWarningLine);
        tips = S.of(context).loadMoreFailed;
        break;
    }

    final Widget child = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) icon,
          if (icon != null) Gap(direction: GapDirection.horizontal),
          if (tips != null) Text(tips),
        ],
      ),
    );

    if (status == LoadingMoreStatus.failed) {
      return Ink(
        child: InkWell(
          onTap: onRetry,
          child: child,
        ),
      );
    }

    return child;
  }
}
