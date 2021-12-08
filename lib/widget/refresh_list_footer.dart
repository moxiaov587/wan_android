import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../contacts/instances.dart';

class RefreshListFooter extends LoadIndicator {
  const RefreshListFooter({
    Key? key,
    VoidCallback? onClick,
    LoadStyle loadStyle = LoadStyle.ShowAlways,
    double height = 60.0,
    this.textStyle,
    this.marginBottom = 0.0,
    this.loadingText,
    this.noDataText,
    this.noMoreIcon,
    this.idleText,
    this.failedText,
    this.canLoadingText,
    this.failedIcon = const Icon(Icons.error),
    this.completeDuration = const Duration(milliseconds: 300),
    this.loadingIcon,
    this.canLoadingIcon = const Icon(Icons.autorenew),
    this.idleIcon = const Icon(Icons.arrow_upward),
  }) : super(
          key: key,
          loadStyle: loadStyle,
          height: height + marginBottom,
          onClick: onClick,
        );

  final String? idleText, loadingText, noDataText, failedText, canLoadingText;

  final Widget? idleIcon, loadingIcon, noMoreIcon, failedIcon, canLoadingIcon;

  final double marginBottom;

  final TextStyle? textStyle;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  @override
  State<StatefulWidget> createState() => _RefreshListFooterState();
}

class _RefreshListFooterState extends LoadIndicatorState<RefreshListFooter> {
  Widget _buildText(LoadStatus? mode) {
    final RefreshString strings =
        RefreshLocalizations.of(context)?.currentLocalization ??
            EnRefreshString();

    late String text;

    switch (mode) {
      case LoadStatus.loading:
        text = widget.loadingText ?? strings.loadingText!;
        break;
      case LoadStatus.noMore:
        text = widget.noDataText ?? strings.noMoreText!;
        break;
      case LoadStatus.failed:
        text = widget.failedText ?? strings.loadFailedText!;
        break;
      case LoadStatus.canLoading:
        text = widget.canLoadingText ?? strings.canLoadingText!;
        break;
      default:
        text = widget.idleText ?? strings.idleLoadingText!;
    }

    return Text(
      text,
      style: widget.textStyle ?? currentTheme.textTheme.bodyText2,
    );
  }

  Widget? _buildIcon(LoadStatus? mode) {
    switch (mode) {
      case LoadStatus.loading:
        return widget.loadingIcon ??
            const SizedBox(
              width: 25.0,
              height: 25.0,
              child: CupertinoActivityIndicator(),
            );
      case LoadStatus.noMore:
        return widget.noMoreIcon;
      case LoadStatus.failed:
        return widget.failedIcon;
      case LoadStatus.canLoading:
        return widget.canLoadingIcon;
      default:
        return widget.idleIcon;
    }
  }

  @override
  Future<void> endLoading() {
    return Future<void>.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    final Widget textWidget = _buildText(mode);
    final Widget iconWidget = _buildIcon(mode) ?? const SizedBox.shrink();

    return SizedBox(
        height: widget.height + widget.marginBottom,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                iconWidget,
                const SizedBox(
                  width: 15.0,
                ),
                textWidget,
              ],
            ),
            SizedBox(
              height: widget.marginBottom,
            ),
          ],
        ));
  }
}
