import 'package:flutter/material.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// `const Divider()` is used by default when [separatorBuilder] is null
///
/// See also:
///  * [SliverChildBuilderDelegate], no [separatorBuilder]
class SliverChildWithSeparatorBuilderDelegate extends SliverChildDelegate {
  const SliverChildWithSeparatorBuilderDelegate(
    this.builder, {
    this.separatorBuilder,
    this.findChildIndexCallback,
    required this.childCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.ignoreSeparatorBuilderForPenultimateChild = false,
  }) : assert(childCount > 1);

  final NullableIndexedWidgetBuilder builder;
  final NullableIndexedWidgetBuilder? separatorBuilder;
  final int childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int semanticIndexOffset;
  final SemanticIndexCallback semanticIndexCallback;
  final ChildIndexGetter? findChildIndexCallback;

  /// The last child's [separatorBuilder] is ignored by default
  ///
  /// [ignoreSeparatorBuilderForPenultimateChild] is used to ignore
  /// the [separatorBuilder] of the last two child when loading more
  final bool ignoreSeparatorBuilderForPenultimateChild;

  @override
  int? findIndexByKey(Key key) {
    if (findChildIndexCallback == null) {
      return null;
    }
    assert(key != null);
    final Key childKey;
    if (key is _SaltedValueKey) {
      final _SaltedValueKey saltedValueKey = key;
      childKey = saltedValueKey.value;
    } else {
      childKey = key;
    }

    return findChildIndexCallback!(childKey);
  }

  @override
  Widget? build(BuildContext context, int index) {
    final int lastChildIndex = estimatedChildCount! - 1;

    if (index < 0 || index > lastChildIndex) {
      return null;
    }

    Widget? child;

    final int itemIndex = index.isEven ? index ~/ 2 : (index - 1) ~/ 2;

    try {
      child = ignoreSeparatorBuilderForPenultimateChild &&
              index == lastChildIndex // last child
          ? builder(context, itemIndex + 1)
          : index.isEven
              ? builder(context, itemIndex)
              : separatorBuilder?.call(context, itemIndex) ?? const Divider();
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }

    if (child == null) {
      return null;
    }

    final Key? key = child.key != null ? _SaltedValueKey(child.key!) : null;

    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }

    if (index.isEven && addSemanticIndexes) {
      final int? semanticIndex = semanticIndexCallback(child, itemIndex);
      if (semanticIndex != null)
        child = IndexedSemantics(
          index: semanticIndex + semanticIndexOffset,
          child: child,
        );
    }
    if (addAutomaticKeepAlives) {
      child = AutomaticKeepAlive(child: child);
    }

    return KeyedSubtree(key: key, child: child);
  }

  @override
  int? get estimatedChildCount => ignoreSeparatorBuilderForPenultimateChild
      ? (childCount - 1) * 2
      : childCount * 2 - 1;

  @override
  bool shouldRebuild(
    covariant SliverChildWithSeparatorBuilderDelegate oldDelegate,
  ) =>
      true;
}

class _SaltedValueKey extends ValueKey<Key> {
  const _SaltedValueKey(super.key) : assert(key != null);
}

// Return a Widget for the given Exception
Widget _createErrorWidget(Object exception, StackTrace stackTrace) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stackTrace,
    library: 'widgets library',
    context: ErrorDescription('building'),
  );
  FlutterError.reportError(details);

  return ErrorWidget.builder(details);
}
