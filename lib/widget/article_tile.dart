part of 'article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    required this.article,
    super.key,
    this.query,
    this.authorTextOrShareUserTextCanOnTap = true,
  });

  final ArticleModel article;
  final String? query;
  final bool authorTextOrShareUserTextCanOnTap;

  @override
  Widget build(BuildContext context) {
    final bool isShare = article.author.strictValue == null;

    final double titleVerticalGap = AppTheme.bodyPadding.top;

    final TextStyle titleStyle = context.theme.textTheme.titleSmall!;

    const TextSpan textSpace = TextSpan(
      text: '${Unicode.halfWidthSpace}•${Unicode.halfWidthSpace}',
      style: TextStyle(wordSpacing: kStyleUint / 2),
    );

    return Material(
      child: Ink(
        decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context)),
        ),
        child: InkWell(
          onTap: () {
            unawaited(ArticleRoute(id: article.id).push(context));
          },
          child: Padding(
            padding: AppTheme.bodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  textScaler: context.mqTextScaler,
                  text: TextSpan(
                    style: context.theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      if (article.author.strictValue != null)
                        TextSpan(
                          text: article.author.strictValue,
                          style: authorTextOrShareUserTextCanOnTap
                              ? TextStyle(color: titleStyle.color)
                              : null,
                          recognizer: authorTextOrShareUserTextCanOnTap
                              ? (TapGestureRecognizer()
                                ..onTap = () {
                                  unawaited(
                                    TheyArticlesRoute(author: article.author!)
                                        .push(context),
                                  );
                                })
                              : null,
                        )
                      else if (article.shareUser.strictValue != null)
                        TextSpan(
                          text: article.shareUser.strictValue,
                          style: authorTextOrShareUserTextCanOnTap
                              ? TextStyle(color: titleStyle.color)
                              : null,
                          recognizer: authorTextOrShareUserTextCanOnTap
                              ? (TapGestureRecognizer()
                                ..onTap = () {
                                  unawaited(
                                    TheyShareRoute(id: article.userId!)
                                        .push(context),
                                  );
                                })
                              : null,
                        ),
                      TextSpan(
                        text: article.publishTime
                                .toDateTimeTranslation(context) ??
                            '',
                      ),
                      TextSpan(
                        text: '${article.chapterName}',
                      ),
                    ].fold<List<TextSpan>>(
                      <TextSpan>[],
                      (List<TextSpan> children, TextSpan child) =>
                          <TextSpan>[...children, child, textSpace],
                    )..removeLast(),
                  ),
                ),
                Gap.v(value: titleVerticalGap),
                ArticleTileSearchTitle(
                  prefixesChildren: <InlineSpan>[
                    if (article.isTop)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _TagTile(
                          text: S.of(context).top,
                          color: context.theme.colorScheme.error,
                          marginRight: true,
                        ),
                      ),
                    if (article.fresh)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _TagTile(
                          text: S.of(context).fresh,
                          color: context.theme.primaryColor,
                          marginRight: true,
                        ),
                      ),
                  ],
                  query: query,
                  title: article.title,
                  textStyle: titleStyle,
                ),
                Gap.v(value: titleVerticalGap),
                Wrap(
                  spacing: kStyleUint2,
                  children: <Widget>[
                    _TagTile(
                      text: isShare
                          ? S.of(context).share
                          : S.of(context).original,
                    ),
                    ...article.tags
                            ?.map(
                              (TagModel tag) => _TagTile(
                                key: UniqueKey(),
                                text: HTMLParseUtils.unescapeHTML(tag.name),
                              ),
                            )
                            .toList() ??
                        <Widget>[],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagTile extends StatelessWidget {
  const _TagTile({
    required this.text,
    super.key,
    this.color,
    this.marginRight = false,
  });

  final String? text;
  final Color? color;
  final bool marginRight;

  @override
  Widget build(BuildContext context) {
    Widget child = Material(
      color: color?.withOpacity(0.1) ??
          context.theme.dividerColor.withAlpha(context.isDarkTheme ? 220 : 90),
      borderRadius: AppTheme.adornmentBorderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kStyleUint,
          vertical: kStyleUint / 4,
        ),
        child: Text(
          text ?? S.of(context).unknown,
          style: context.theme.textTheme.bodySmall!.copyWith(
            color: color,
            fontSize: AppTextTheme.label3,
            height: 1.4,
          ),
        ),
      ),
    );

    if (marginRight) {
      child = Padding(
        padding: const EdgeInsets.only(right: kStyleUint),
        child: child,
      );
    }

    return child;
  }
}
