part of 'view_state_widget.dart';

class CustomErrorWidget extends ConsumerWidget {
  const CustomErrorWidget({
    super.key,
    this.statusCode,
    this.message,
    this.detail,
    this.onRetry,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDisconnected =
        ref.read(connectivityProvider.notifier).isDisconnected;

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
              isDisconnected ? Assets.ASSETS_IMAGES_TIMEOUT_PNG : errorImage,
              width: 120,
            ),
            Text(
              isDisconnected
                  ? S.of(context).networkException
                  : message ?? S.of(context).unknownError,
              style: context.theme.textTheme.titleSmall,
            ),
            Gap(
              size: GapSize.small,
            ),
            Text(
              isDisconnected
                  ? S.of(context).networkExceptionMsg
                  : detail ?? S.of(context).unknownErrorMsg,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyMedium,
            ),
            if (onRetry != null) Gap(),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: Text(S.of(context).retry),
              ),
          ],
        ),
      ),
    );
  }
}
