import 'package:flutter/material.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/theme.dart';
import '../contacts/instances.dart';
import '../contacts/unicode.dart';
import '../extensions/extensions.dart';
import '../model/models.dart';
import '../navigator/router_delegate.dart';
import '../widget/gap.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.article,
    this.query,
  }) : super(key: key);

  final ArticleModel article;
  final String? query;

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
                    text: article.author.strictValue ??
                        article.shareUser.strictValue ??
                        'null',
                    style: currentTheme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      _textSpace,
                      TextSpan(
                        text: article.niceDate,
                      ),
                      _textSpace,
                      TextSpan(
                        text:
                            '${article.superChapterName.mustNotEmpty ? '${article.superChapterName}/' : ''}'
                            '${article.chapterName}',
                      )
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
                    article.title,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleTileSearchTitle extends StatelessWidget {
  const ArticleTileSearchTitle({
    Key? key,
    required this.query,
    required this.title,
    required this.textStyle,
  }) : super(key: key);

  final String query;
  final String title;
  final TextStyle textStyle;

  List<String> get keywords => query.split(Unicode.halfWidthSpace).toList();

  List<String> get words => title
      .replaceAllMapped(RegExp(r'<[a-zA-Z]+.*?>([\s\S]*?)</[a-zA-Z]*?>'),
          (Match match) {
        final String? value = match.group(1);

        if (value != null) {
          return ',$value,';
        }

        return '';
      })
      .split(',')
      .where((String word) => word.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final Color keywordsBackgroundColor =
        (currentIsDark ? AppColor.yellowDark : AppColor.yellow).withOpacity(.2);

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: words.map((String word) {
          final bool isKeywords = keywords.contains(word);

          return TextSpan(
            text: word,
            style: TextStyle(
              backgroundColor: isKeywords ? keywordsBackgroundColor : null,
              color: isKeywords ? currentTheme.errorColor : null,
            ),
          );
        }).toList(),
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
          text ?? 'null',
          style: currentTheme.textTheme.bodySmall!.copyWith(
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
