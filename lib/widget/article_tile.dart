part of 'article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.article,
    this.query,
    this.authorTextOrShareUserTextCanOnTap = true,
  }) : super(key: key);

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

    final EdgeInsetsGeometry contentPadding = AppTheme.bodyPadding;

    final double titleVerticalGap = contentPadding.vertical / 2;

    final TextStyle titleStyle = currentTheme.textTheme.titleSmall!;

    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {
            AppRouterDelegate.instance.currentBeamState.updateWith(
              articleId: article.id,
            );
          },
          child: Padding(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: currentTheme.textTheme.bodyMedium,
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
                    query: query!,
                    title: article.title,
                    textStyle: titleStyle,
                  )
                else
                  Text(
                    HTMLParseUtils.parseArticleTitle(title: article.title) ??
                        S.of(context).unknown,
                    style: titleStyle,
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
                            (TagModel e) => _TagTile(
                              text: e.name,
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
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: currentTheme.dividerColor.withAlpha(currentIsDark ? 220 : 90),
      borderRadius: AppTheme.adornmentBorderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kStyleUint,
          vertical: kStyleUint / 2,
        ),
        child: Text(
          text ?? S.of(context).unknown,
          style: currentTheme.textTheme.bodySmall!.copyWith(
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
