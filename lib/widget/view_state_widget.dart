import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

import '../contacts/assets.dart';
import '../contacts/instances.dart';
import 'gap.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.radius = 25.0,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: radius,
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    this.message,
    this.detail,
    this.onRetry,
  }) : super(key: key);

  final String? message;
  final String? detail;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Assets.ASSETS_IMAGES_EMPTY_PNG,
            width: 180,
          ),
          Text(
            message ?? 'empty',
            style: currentTheme.textTheme.subtitle1,
          ),
          Gap(
            size: GapSize.small,
          ),
          Text(
            detail ?? 'empty',
            style: currentTheme.textTheme.bodyText2,
          ),
          if (onRetry != null) Gap(),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text('retry'),
            ),
        ],
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    Key? key,
    this.statusCode,
    this.message,
    this.detail,
    this.onRetry,
  }) : super(key: key);

  final int? statusCode;
  final String? message;
  final String? detail;
  final VoidCallback? onRetry;

  String get errorImage {
    switch (statusCode) {
      case 400:
      case 403:
        return Assets.ASSETS_IMAGES_400_PNG;
      case 404:
        return Assets.ASSETS_IMAGES_404_PNG;
      case 500:
      case 503:
        return Assets.ASSETS_IMAGES_500_PNG;
      default:
        return Assets.ASSETS_IMAGES_UNKNOWN_ERROR_PNG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            errorImage,
            width: 120,
          ),
          Text(
            message ?? 'unknown',
            style: currentTheme.textTheme.subtitle1,
          ),
          Gap(
            size: GapSize.small,
          ),
          Text(
            detail ?? 'unknown',
            style: currentTheme.textTheme.bodyText2,
          ),
          if (onRetry != null) Gap(),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text('retry'),
            ),
        ],
      ),
    );
  }
}
