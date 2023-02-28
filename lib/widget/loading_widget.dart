part of 'view_state_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget.listView({
    super.key,
  })  : radius = 25.0,
        warpWithCenter = true;

  const LoadingWidget.capsuleInk({
    super.key,
  })  : radius = kStyleUint2,
        warpWithCenter = false;

  final double radius;
  final bool warpWithCenter;

  @override
  Widget build(BuildContext context) {
    Widget child = CupertinoActivityIndicator(radius: radius);

    if (warpWithCenter) {
      child = Center(child: child);
    }

    return child;
  }
}
