import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../contacts/instances.dart';

class DropDownListHeader extends RefreshIndicator {
  const DropDownListHeader({
    Key? key,
    RefreshStyle refreshStyle = RefreshStyle.Follow,
    double height = 60.0,
    Duration completeDuration = const Duration(milliseconds: 600),
    this.textStyle,
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.refreshingIcon,
    this.failedIcon = const Icon(Icons.error),
    this.completeIcon = const Icon(Icons.done),
    this.idleIcon = const Icon(Icons.arrow_downward),
    this.releaseIcon = const Icon(Icons.refresh),
  }) : super(
          key: key,
          refreshStyle: refreshStyle,
          completeDuration: completeDuration,
          height: height,
        );

  final String? releaseText,
      idleText,
      refreshingText,
      completeText,
      failedText,
      canTwoLevelText;
  final Widget? releaseIcon,
      idleIcon,
      refreshingIcon,
      completeIcon,
      failedIcon,
      canTwoLevelIcon,
      twoLevelView;

  final TextStyle? textStyle;

  @override
  State createState() {
    return _DropDownListHeaderState();
  }
}

class _DropDownListHeaderState
    extends RefreshIndicatorState<DropDownListHeader> {
  Widget _buildText(RefreshStatus? mode) {
    final RefreshString strings =
        RefreshLocalizations.of(context)?.currentLocalization ??
            EnRefreshString();

    late String text;

    switch (mode) {
      case RefreshStatus.canRefresh:
        text = widget.releaseText ?? strings.canRefreshText!;
        break;
      case RefreshStatus.completed:
        text = widget.completeText ?? strings.refreshCompleteText!;
        break;
      case RefreshStatus.failed:
        text = widget.failedText ?? strings.refreshFailedText!;
        break;
      case RefreshStatus.refreshing:
        text = widget.refreshingText ?? strings.refreshingText!;
        break;
      case RefreshStatus.idle:
        text = widget.idleText ?? strings.idleRefreshText!;
        break;
      case RefreshStatus.canTwoLevel:
        text = widget.canTwoLevelText ?? strings.canTwoLevelText!;
        break;
      default:
        text = '';
    }

    return Text(
      text,
      style: widget.textStyle ?? currentTheme.textTheme.subtitle1,
    );
  }

  Widget? _buildIcon(RefreshStatus? mode) {
    switch (mode) {
      case RefreshStatus.canRefresh:
        return widget.releaseIcon;
      case RefreshStatus.completed:
        return widget.completeIcon;
      case RefreshStatus.failed:
        return widget.failedIcon;
      case RefreshStatus.refreshing:
        return widget.refreshingIcon ??
            const SizedBox(
              width: 25.0,
              height: 25.0,
              child: CupertinoActivityIndicator(),
            );
      case RefreshStatus.idle:
        return widget.idleIcon;
      case RefreshStatus.canTwoLevel:
        return widget.canTwoLevelIcon;
      default:
        return widget.twoLevelView;
    }
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    final Widget textWidget = _buildText(mode);
    final Widget iconWidget = _buildIcon(mode) ?? const SizedBox.shrink();

    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          iconWidget,
          const SizedBox(
            width: 15.0,
          ),
          textWidget,
        ],
      ),
    );
  }
}

class LoadMoreListFooter extends LoadIndicator {
  const LoadMoreListFooter({
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
  State<StatefulWidget> createState() => _LoadMoreListFooterState();
}

class _LoadMoreListFooterState extends LoadIndicatorState<LoadMoreListFooter> {
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
      style: widget.textStyle ?? currentTheme.textTheme.subtitle1,
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
