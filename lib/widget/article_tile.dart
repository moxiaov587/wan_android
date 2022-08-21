part of 'article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
    this.query,
    this.authorTextOrShareUserTextCanOnTap = true,
  });

  final ArticleModel article;
  final String? query;

  final bool authorTextOrShareUserTextCanOnTap;

  TextSpan get _textSpace => const TextSpan(
        text: '${Unicode.halfWidthSpace}•${Unicode.halfWidthSpace}',
        style: TextStyle(
          wordSpacing: kStyleUint / 2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool isShare = article.author.strictValue == null;

    final bool hasTags = article.tags != null && article.tags!.isNotEmpty;

    final double titleVerticalGap = AppTheme.bodyPadding.top;

    final TextStyle titleStyle = context.theme.textTheme.titleSmall!;

    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            AppRouterDelegate.instance.currentBeamState.updateWith(
              articleId: article.id,
            );
          },
          child: Padding(
            padding: AppTheme.bodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: context.theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      if (article.author.strictValue != null)
                        TextSpan(
                          text: article.author.strictValue,
                          style: authorTextOrShareUserTextCanOnTap
                              ? TextStyle(
                                  color: titleStyle.color,
                                )
                              : null,
                          recognizer: authorTextOrShareUserTextCanOnTap
                              ? (TapGestureRecognizer()
                                ..onTap = () {
                                  AppRouterDelegate.instance.currentBeamState
                                      .updateWith(
                                    author: article.author,
                                  );
                                })
                              : null,
                        )
                      else if (article.shareUser.strictValue != null)
                        TextSpan(
                          text: article.shareUser.strictValue,
                          style: authorTextOrShareUserTextCanOnTap
                              ? TextStyle(
                                  color: titleStyle.color,
                                )
                              : null,
                          recognizer: authorTextOrShareUserTextCanOnTap
                              ? (TapGestureRecognizer()
                                ..onTap = () {
                                  AppRouterDelegate.instance.currentBeamState
                                      .updateWith(
                                    userId: article.userId,
                                  );
                                })
                              : null,
                        ),
                      if (article.author.strictValue == null ||
                          article.shareUser.strictValue == null)
                        _textSpace,
                      TextSpan(
                        text: article.niceDate,
                      ),
                      _textSpace,
                      TextSpan(
                        text:
                            '${article.superChapterName.mustNotEmpty ? '${article.superChapterName}/' : ''}'
                            '${article.chapterName}',
                      ),
                    ],
                  ),
                ),
                Gap(
                  value: titleVerticalGap,
                ),
                if (query != null)
                  ArticleTileSearchTitle(
                    prefixesChildren: <InlineSpan>[
                      if (article.fresh)
                        WidgetSpan(
                          child: _TagTile(
                            text: S.of(context).fresh,
                            color: context.theme.primaryColor,
                            marginRight: true,
                          ),
                        ),
                    ],
                    query: query!,
                    title: article.title,
                    textStyle: titleStyle,
                  )
                else
                  RichText(
                    text: TextSpan(
                      style: titleStyle,
                      children: <InlineSpan>[
                        if (article.isTop)
                          WidgetSpan(
                            child: _TagTile(
                              text: S.of(context).top,
                              color: context.theme.colorScheme.error,
                              marginRight: true,
                            ),
                          ),
                        if (article.fresh)
                          WidgetSpan(
                            child: _TagTile(
                              text: S.of(context).fresh,
                              color: context.theme.primaryColor,
                              marginRight: true,
                            ),
                          ),
                        TextSpan(
                          text: HTMLParseUtils.unescapeHTML(article.title) ??
                              S.of(context).unknown,
                        ),
                      ],
                    ),
                  ),
                Gap(
                  value: titleVerticalGap,
                ),
                Wrap(
                  spacing: kStyleUint2,
                  children: <Widget>[
                    _TagTile(
                      text: isShare
                          ? S.of(context).share
                          : S.of(context).original,
                    ),
                    if (hasTags)
                      ...article.tags!
                          .map(
                            (TagModel tag) => _TagTile(
                              key: UniqueKey(),
                              text: HTMLParseUtils.unescapeHTML(tag.name),
                            ),
                          )
                          .toList(),
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
    super.key,
    required this.text,
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
          vertical: kStyleUint / 2,
        ),
        child: Text(
          text ?? S.of(context).unknown,
          style: context.theme.textTheme.bodySmall!.copyWith(
            color: color,
            height: 1.35,
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
