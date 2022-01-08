import 'package:flutter/material.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/theme.dart';
import '../contacts/instances.dart';
import '../extensions/extensions.dart';
import '../model/models.dart';
import '../widget/gap.dart';

const double _kArticleSmallSpace = 2.0;

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.article,
  }) : super(key: key);

  final ArticleModel article;

  TextSpan get _textSpace => const TextSpan(
        text: ' • ',
        style: TextStyle(
          wordSpacing: _kArticleSmallSpace,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool isShare = article.author.strictValue == null;

    final bool hasTags = article.tags != null && article.tags!.isNotEmpty;

    final EdgeInsetsGeometry contentPadding = AppTheme.bodyPadding;

    final double titleVerticalGap = contentPadding.vertical / 2;
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: AppTheme.bodyPadding,
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
                Text(
                  article.title,
                  style: currentTheme.textTheme.titleSmall,
                ),
                Gap(
                  value: titleVerticalGap,
                ),
                Wrap(
                  spacing: _kArticleSmallSpace * 4,
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
          horizontal: _kArticleSmallSpace * 2,
          vertical: _kArticleSmallSpace,
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
