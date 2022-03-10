import 'dart:math' as math;

import 'package:flutter/material.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class CustomSliverChildBuilderDelegate {
  CustomSliverChildBuilderDelegate._();

  // ignore: long-parameter-list
  static SliverChildBuilderDelegate separated({
    required Widget Function(BuildContext, int) itemBuilder,
    Widget Function(BuildContext, int)? separatorBuilder,
    required int itemCount,
    ChildIndexGetter? findChildIndexCallback,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback =
        _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        final int itemIndex = index ~/ 2;
        final Widget widget;
        widget = index.isEven
            ? itemBuilder(context, itemIndex)
            : separatorBuilder?.call(context, itemIndex) ?? const Divider();

        return widget;
      },
      childCount: math.max(
        0,
        itemCount * 2 - 1,
      ),
      findChildIndexCallback: findChildIndexCallback,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      semanticIndexCallback: semanticIndexCallback,
      semanticIndexOffset: semanticIndexOffset,
    );
  }
}
