import 'package:extended_list/extended_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' hide ViewportBuilder;

import '../../../widget/sliver_child_with_separator_builder_delegate.dart';

typedef LoadMoreIndicatorBuilder = Widget Function(BuildContext context);

class LoadMoreList<T> extends StatelessWidget {
  const LoadMoreList({
    super.key,
    required this.list,
    this.loadMoreIndicatorBuilder,
    required this.itemBuilder,
    required this.onScrollNotification,
    this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.semanticChildCount,
    this.padding = EdgeInsets.zero,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.lastChildLayoutTypeBuilder,
    this.collectGarbage,
    this.viewportBuilder,
    this.closeToTrailing,
  });

  final List<T> list;
  final LoadMoreIndicatorBuilder? loadMoreIndicatorBuilder;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final bool Function(ScrollNotification notification) onScrollNotification;

  // [ListView] params
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double? cacheExtent;
  final int? semanticChildCount;
  final EdgeInsetsGeometry padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  // [ExtendedListDelegate] params
  final LastChildLayoutTypeBuilder? lastChildLayoutTypeBuilder;
  final CollectGarbage? collectGarbage;
  final ViewportBuilder? viewportBuilder;
  final bool? closeToTrailing;

  bool get canLoadMore => loadMoreIndicatorBuilder != null;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    final ExtendedListDelegate extendedListDelegate = ExtendedListDelegate(
      lastChildLayoutTypeBuilder: lastChildLayoutTypeBuilder ??
          (canLoadMore // Add default [lastChildLayoutTypeBuilder] when loading more
              ? (int index) => index == list.length
                  ? LastChildLayoutType.fullCrossAxisExtent
                  : LastChildLayoutType.none
              : null),
      collectGarbage: collectGarbage,
      viewportBuilder: viewportBuilder,
      closeToTrailing: closeToTrailing ?? false,
    );

    int length = list.length;

    if (separatorBuilder != null) {
      length = length * 2 - 1;

      if (canLoadMore) {
        length += 1;
      }

      child = ExtendedListView.separated(
        separatorBuilder: separatorBuilder!,
        itemBuilder: (BuildContext context, int index) {
          if (canLoadMore && index == list.length) {
            return loadMoreIndicatorBuilder!.call(context);
          }

          return itemBuilder.call(context, index);
        },
        extendedListDelegate: extendedListDelegate,
        itemCount: length,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
      );
    } else {
      if (canLoadMore) {
        length += 1;
      }

      child = ExtendedListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (canLoadMore && index == list.length) {
            return loadMoreIndicatorBuilder!.call(context);
          }

          return itemBuilder.call(context, index);
        },
        extendedListDelegate: extendedListDelegate,
        itemCount: length,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
      );
    }

    if (loadMoreIndicatorBuilder == null) {
      return child;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: child,
    );
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class LoadMoreSliverList<T> extends StatelessWidget {
  const LoadMoreSliverList({
    super.key,
    required this.list,
    this.loadMoreIndicatorBuilder,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.lastChildLayoutTypeBuilder,
    this.collectGarbage,
    this.viewportBuilder,
    this.closeToTrailing,
  });

  final List<T> list;
  final LoadMoreIndicatorBuilder? loadMoreIndicatorBuilder;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  // [ListView] params
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;

  // [ExtendedListDelegate] params
  final LastChildLayoutTypeBuilder? lastChildLayoutTypeBuilder;
  final CollectGarbage? collectGarbage;
  final ViewportBuilder? viewportBuilder;
  final bool? closeToTrailing;

  bool get canLoadMore => loadMoreIndicatorBuilder != null;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    final ExtendedListDelegate extendedListDelegate = ExtendedListDelegate(
      lastChildLayoutTypeBuilder: lastChildLayoutTypeBuilder ??
          (canLoadMore // Add default [lastChildLayoutTypeBuilder] when loading more
              ? (int index) => index == list.length
                  ? LastChildLayoutType.fullCrossAxisExtent
                  : LastChildLayoutType.none
              : null),
      collectGarbage: collectGarbage,
      viewportBuilder: viewportBuilder,
      closeToTrailing: closeToTrailing ?? false,
    );

    if (itemExtent != null) {
      int length = list.length;

      if (separatorBuilder != null) {
        if (canLoadMore) {
          length += 1;
        }

        child = ExtendedSliverFixedExtentList(
          itemExtent: itemExtent!,
          extendedListDelegate: extendedListDelegate,
          delegate: SliverChildWithSeparatorBuilderDelegate(
            (BuildContext context, int index) {
              if (canLoadMore && index == length - 1) {
                return loadMoreIndicatorBuilder!.call(context);
              }

              return itemBuilder(context, index);
            },
            separatorBuilder: separatorBuilder,
            childCount: length,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            ignoreSeparatorBuilderForPenultimateChild: true,
          ),
        );
      } else {
        if (canLoadMore) {
          length += 1;
        }

        child = ExtendedSliverFixedExtentList(
          itemExtent: itemExtent!,
          extendedListDelegate: extendedListDelegate,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (canLoadMore && index == list.length) {
                return loadMoreIndicatorBuilder!.call(context);
              }

              return itemBuilder.call(context, index);
            },
            childCount: length,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
          ),
        );
      }
    } else {
      int length = list.length;

      if (separatorBuilder != null) {
        if (canLoadMore) {
          length += 1;
        }

        child = ExtendedSliverList(
          extendedListDelegate: extendedListDelegate,
          delegate: SliverChildWithSeparatorBuilderDelegate(
            (BuildContext context, int index) {
              if (canLoadMore && index == length - 1) {
                return loadMoreIndicatorBuilder!.call(context);
              }

              return itemBuilder(context, index);
            },
            separatorBuilder: separatorBuilder,
            childCount: length,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            ignoreSeparatorBuilderForPenultimateChild: true,
          ),
        );
      } else {
        if (canLoadMore) {
          length += 1;
        }

        child = ExtendedSliverList(
          extendedListDelegate: extendedListDelegate,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (canLoadMore && index == list.length) {
                return loadMoreIndicatorBuilder!.call(context);
              }

              return itemBuilder.call(context, index);
            },
            childCount: length,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
          ),
        );
      }
    }

    if (padding != null) {
      child = SliverPadding(
        padding: padding!,
        sliver: child,
      );
    }

    return child;
  }
}
