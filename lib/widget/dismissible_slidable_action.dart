import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/l10n/generated/l10n.dart';

class DismissibleSlidableAction extends StatefulWidget {
  const DismissibleSlidableAction({
    required this.slidableExtentRatio,
    required this.dismissiblePaneThreshold,
    required this.label,
    required this.onTap,
    super.key,
    this.color,
  });

  final double slidableExtentRatio;
  final double dismissiblePaneThreshold;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  State<DismissibleSlidableAction> createState() =>
      _DismissibleSlidableActionState();
}

class _DismissibleSlidableActionState extends State<DismissibleSlidableAction> {
  late final SlidableController slidable = Slidable.of(context)!;

  Animation<double> get slidableAnimation => slidable.animation;

  late final ValueNotifier<ActionLabel> _actionLabelNotifier =
      ValueNotifier<ActionLabel>(
    ActionLabel(
      label: widget.label,
      color: widget.color ?? context.theme.primaryColor,
    ),
  );

  double maxValue = 0;

  double get slidableAnimationValue => slidableAnimation.value;

  @override
  void initState() {
    super.initState();

    slidableAnimation
      ..addListener(handleValueChanged)
      ..addStatusListener(handleStatusChanged);
  }

  void handleValueChanged() {
    if (slidableAnimationValue > maxValue) {
      maxValue = slidableAnimationValue;

      if (slidableAnimationValue > widget.slidableExtentRatio &&
          slidableAnimationValue < widget.dismissiblePaneThreshold) {
        _actionLabelNotifier.value = ActionLabel(
          label: S.of(context).keepSwipingLeftToDelete,
          color: context.theme.colorScheme.tertiary,
        );
      } else if (slidableAnimationValue >= widget.dismissiblePaneThreshold) {
        _actionLabelNotifier.value = ActionLabel(
          label: S.of(context).releaseToDeleteSwipeRightToCancel,
          color: context.theme.colorScheme.error,
        );
      }
    } else {
      if (slidableAnimationValue <= widget.slidableExtentRatio) {
        _actionLabelNotifier.value = ActionLabel(
          label: widget.label,
          color: widget.color ?? context.theme.primaryColor,
        );
      } else if (slidableAnimationValue > widget.slidableExtentRatio &&
          slidableAnimationValue < widget.dismissiblePaneThreshold) {
        _actionLabelNotifier.value = ActionLabel(
          label: S.of(context).keepSwipingLeftToDelete,
          color: context.theme.colorScheme.tertiary,
        );
      }
    }
  }

  void handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      maxValue = 0;
    }
  }

  @override
  void dispose() {
    _actionLabelNotifier.dispose();
    slidableAnimation
      ..removeListener(handleValueChanged)
      ..removeStatusListener(handleStatusChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ActionLabel>(
        valueListenable: _actionLabelNotifier,
        builder: (_, ActionLabel actionLabel, __) => Expanded(
          child: Material(
            child: SizedBox.expand(
              child: Ink(
                color: actionLabel.color,
                child: InkWell(
                  onTap: () {
                    unawaited(slidable.close());
                    widget.onTap();
                  },
                  child: Center(
                    child: Text(
                      actionLabel.label,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyMedium!.copyWith(
                        color: context.theme.tooltipTheme.textStyle!.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

@immutable
class ActionLabel {
  const ActionLabel({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  bool operator ==(Object other) =>
      other is ActionLabel && label == other.label && color == other.color;

  @override
  int get hashCode => Object.hash(label, color);
}
