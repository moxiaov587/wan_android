part of 'view_state_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.radius = 25.0,
    this.warpWithCenter = true,
  });

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
