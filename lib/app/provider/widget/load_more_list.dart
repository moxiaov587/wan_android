import 'package:flutter/widgets.dart';

import '../../../widget/sliver_child_with_separator_builder_delegate.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class LoadMoreSliverList extends StatelessWidget {
  const LoadMoreSliverList({
    super.key,
    required this.loadMoreIndicatorBuilder,
    required this.itemBuilder,
    required this.itemCount,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  }) : separatorBuilder = null;

  const LoadMoreSliverList.separator({
    super.key,
    required this.loadMoreIndicatorBuilder,
    required this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    required this.itemCount,
    this.padding,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  })  : itemExtent = null,
        prototypeItem = null;

  final WidgetBuilder loadMoreIndicatorBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  final double? itemExtent;
  final Widget? prototypeItem;

  final ChildIndexGetter? findChildIndexCallback;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    final int childCount = itemCount + 1;

    if (itemExtent != null) {
      child = SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == itemCount) {
              return loadMoreIndicatorBuilder.call(context);
            }

            return itemBuilder.call(context, index);
          },
          childCount: childCount,
          findChildIndexCallback: findChildIndexCallback,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        ),
        itemExtent: itemExtent!,
      );
    } else if (prototypeItem != null) {
      child = SliverPrototypeExtentList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == itemCount) {
              return loadMoreIndicatorBuilder.call(context);
            }

            return itemBuilder.call(context, index);
          },
          childCount: childCount,
          findChildIndexCallback: findChildIndexCallback,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        ),
        prototypeItem: prototypeItem!,
      );
    } else {
      final SliverChildDelegate childrenDelegate = separatorBuilder != null
          ? SliverChildWithSeparatorBuilderDelegate(
              (BuildContext context, int index) {
                if (index == itemCount) {
                  return loadMoreIndicatorBuilder.call(context);
                }

                return itemBuilder.call(context, index);
              },
              childCount: childCount,
              separatorBuilder: separatorBuilder,
              ignoreSeparatorBuilderForPenultimateChild: true,
              findChildIndexCallback: findChildIndexCallback,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              semanticIndexCallback: semanticIndexCallback,
              semanticIndexOffset: semanticIndexOffset,
            )
          : SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == itemCount) {
                  return loadMoreIndicatorBuilder.call(context);
                }

                return itemBuilder.call(context, index);
              },
              childCount: childCount,
              findChildIndexCallback: findChildIndexCallback,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              semanticIndexCallback: semanticIndexCallback,
              semanticIndexOffset: semanticIndexOffset,
            );

      child = SliverList(
        delegate: childrenDelegate,
      );
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
