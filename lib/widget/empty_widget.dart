part of 'view_state_widget.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.message,
    this.detail,
    this.onRetry,
  });

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
