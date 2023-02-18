part of 'view_state_widget.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.message,
    this.detail,
    this.onRetry,
  }) : _assets = Assets.ASSETS_IMAGES_EMPTY_PNG;

  const EmptyWidget.favorites({
    super.key,
    this.message,
    this.detail,
    this.onRetry,
  }) : _assets = Assets.ASSETS_IMAGES_FAVORITES_EMPTY_PNG;

  const EmptyWidget.search({
    super.key,
    this.message,
    this.detail,
    this.onRetry,
  }) : _assets = Assets.ASSETS_IMAGES_SEARCH_EMPTY_PNG;

  final String _assets;
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
            _assets,
            width: 180,
          ),
          Text(
            message ?? S.of(context).empty,
            style: context.theme.textTheme.titleSmall,
          ),
          Gap(
            size: GapSize.small,
          ),
          Text(
            detail ?? S.of(context).emptyMsg,
            style: context.theme.textTheme.bodyMedium,
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
