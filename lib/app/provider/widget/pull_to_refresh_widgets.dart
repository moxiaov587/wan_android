import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:nil/nil.dart';

import '../../../contacts/icon_font_icons.dart';
import '../../../widget/gap.dart';
import '../../../widget/view_state_widget.dart';
import '../../l10n/generated/l10n.dart';
import '../../theme/app_theme.dart';

enum LoadingMoreStatus {
  loading,
  completed,
  noData,
  failed,
}

class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({
    required this.status,
    required this.onRetry,
    super.key,
  });

  final LoadingMoreStatus status;

  final AsyncCallback onRetry;

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
        icon = const LoadingWidget.capsuleInk();
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
      padding: const EdgeInsets.symmetric(vertical: kStyleUint * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon,
            const Gap.hn(),
          ],
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
