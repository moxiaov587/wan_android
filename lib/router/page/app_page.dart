part of '../app_router.dart';

@immutable
class AppPage<T> extends Page<T> {
  const AppPage({
    super.key,
    super.name,
    required WidgetBuilder this.builder,
    bool this.fullScreenDialog = false,
    bool this.maintainState = false,
  }) : routeBuilder = null;

  const AppPage.routeBuilder({
    super.key,
    super.name,
    required Route<T> Function(BuildContext context, RouteSettings settings)
        this.routeBuilder,
  })  : builder = null,
        fullScreenDialog = null,
        maintainState = null;

  final WidgetBuilder? builder;

  final Route<T> Function(BuildContext context, RouteSettings settings)?
      routeBuilder;

  final bool? fullScreenDialog;

  final bool? maintainState;

  @override
  Route<T> createRoute(BuildContext context) {
    if (routeBuilder != null) {
      return routeBuilder!(context, this);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoPageRoute<T>(
          builder: builder!,
          settings: this,
          maintainState: maintainState!,
          fullscreenDialog: fullScreenDialog!,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return MaterialPageRoute<T>(
          builder: builder!,
          settings: this,
          maintainState: maintainState!,
          fullscreenDialog: fullScreenDialog!,
        );
    }
  }
}

@immutable
class AppModalBottomSheetPage<T> extends Page<T> {
  const AppModalBottomSheetPage({
    this.useRootNavigator = false,
    required this.builder,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled = false,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
  });

  final bool useRootNavigator;
  final WidgetBuilder builder;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool isDismissible;
  final bool enableDrag;
  final bool isScrollControlled;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;
  final bool useSafeArea;

  @override
  Route<T> createRoute(BuildContext context) {
    final NavigatorState navigator =
        Navigator.of(context, rootNavigator: useRootNavigator);

    const Radius radius = Radius.circular(20);

    return ModalBottomSheetRoute<T>(
      builder: builder,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      constraints: constraints,
      modalBarrierColor: context.theme.colorScheme.scrim,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      settings: this,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea,
    );
  }
}
