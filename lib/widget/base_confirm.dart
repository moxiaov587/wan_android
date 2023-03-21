part of '../utils/dialog_utils.dart';

const double _kDialogWidth = 270.0;
const double _kDialogContentMinHeight = 60.0;
const double _kDialogBottomActionHeight = 44.0;
const double _kDialogDividerWidth = 1.0;

class BaseConfirm extends StatelessWidget {
  const BaseConfirm({
    required this.title,
    required this.builder,
    required this.confirmText,
    required this.cancelText,
    required this.confirmHandle,
    required this.cancelHandle,
    required this.isDanger,
    super.key,
  });

  final String? title;
  final Widget Function(BuildContext context) builder;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback confirmHandle;
  final VoidCallback cancelHandle;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    const double bottomActionButtonWidth =
        _kDialogWidth / 2 - _kDialogDividerWidth / 2;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: _kDialogWidth),
      child: Material(
        borderRadius: AppTheme.borderRadius,
        color: context.theme.colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: AppTheme.bodyPadding,
              child: Align(
                child: Text(
                  title ??
                      (isDanger ? S.of(context).warning : S.of(context).tips),
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
            ),
            const Divider(
              height: _kDialogDividerWidth,
              indent: 0.0,
              endIndent: 0.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _kDialogContentMinHeight,
                maxHeight: ScreenUtils.height / 2,
              ),
              child: SingleChildScrollView(
                padding: AppTheme.confirmDialogContextPadding,
                child: DefaultTextStyle(
                  style: context.theme.textTheme.titleSmall!,
                  child: builder.call(context),
                ),
              ),
            ),
            const Divider(
              height: _kDialogDividerWidth,
              indent: 0.0,
              endIndent: 0.0,
            ),
            Row(
              children: <Widget>[
                Ink(
                  width: bottomActionButtonWidth,
                  height: _kDialogBottomActionHeight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: AppTheme.radius,
                    ),
                  ),
                  child: InkWell(
                    onTap: cancelHandle,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: AppTheme.radius,
                    ),
                    child: Align(
                      child: Text(
                        cancelText ?? S.of(context).cancel,
                        style: context.theme.textTheme.titleMedium!.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _kDialogDividerWidth,
                  height: _kDialogBottomActionHeight,
                  child: VerticalDivider(
                    width: _kDialogDividerWidth,
                    thickness: AppTheme.dividerTheme.thickness,
                    indent: 0.0,
                    endIndent: 0.0,
                    color: context.theme.dividerColor,
                  ),
                ),
                Ink(
                  width: bottomActionButtonWidth,
                  height: _kDialogBottomActionHeight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: AppTheme.radius,
                    ),
                  ),
                  child: InkWell(
                    onTap: confirmHandle,
                    borderRadius: const BorderRadius.only(
                      bottomRight: AppTheme.radius,
                    ),
                    child: Align(
                      child: Text(
                        confirmText ??
                            (isDanger
                                ? S.of(context).delete
                                : S.of(context).ok),
                        style: context.theme.textTheme.titleMedium!.semiBold
                            .copyWith(
                          color: isDanger
                              ? context.theme.colorScheme.error
                              : context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
