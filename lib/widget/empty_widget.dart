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
  Widget build(BuildContext context) => Center(
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
            const Gap.vs(),
            Text(
              detail ?? S.of(context).emptyMsg,
              style: context.theme.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...<Widget>[
              const Gap.vn(),
              ElevatedButton(
                onPressed: onRetry,
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 32.0),
                  ),
                ),
                child: Text(S.of(context).retry),
              ),
            ],
          ],
        ),
      );
}
