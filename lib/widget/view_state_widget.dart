import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/theme.dart';
import '../contacts/assets.dart';
import '../contacts/instances.dart';
import 'gap.dart';

const Size _kRetryButtonSize = Size(64.0, 36.0);

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
            message ?? S.of(context).empty,
            style: currentTheme.textTheme.titleSmall,
          ),
          Gap(
            size: GapSize.small,
          ),
          Text(
            detail ?? S.of(context).emptyMsg,
            style: currentTheme.textTheme.bodyMedium,
          ),
          if (onRetry != null) Gap(),
          if (onRetry != null)
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(_kRetryButtonSize),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: AppTextTheme.body1,
                  ),
                ),
              ),
              onPressed: onRetry,
              child: Text(S.of(context).retry),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kStyleUint4,
          vertical: kStyleUint4 * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              errorImage,
              width: 120,
            ),
            Text(
              message ?? S.of(context).unknown,
              style: currentTheme.textTheme.titleSmall,
            ),
            Gap(
              size: GapSize.small,
            ),
            Text(
              detail ?? S.of(context).unknownMsg,
              textAlign: TextAlign.center,
              style: currentTheme.textTheme.bodyMedium,
            ),
            if (onRetry != null) Gap(),
            if (onRetry != null)
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(_kRetryButtonSize),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: AppTextTheme.body1,
                    ),
                  ),
                ),
                onPressed: onRetry,
                child: Text(S.of(context).retry),
              ),
          ],
        ),
      ),
    );
  }
}
