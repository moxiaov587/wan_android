part of 'article.dart';

class ArticleTileSearchTitle extends StatelessWidget {
  const ArticleTileSearchTitle({
    required this.title,
    required this.textStyle,
    super.key,
    this.query,
    this.prefixesChildren = const <InlineSpan>[],
  });

  final String title;
  final TextStyle textStyle;
  final String? query;
  final List<InlineSpan> prefixesChildren;

  @override
  Widget build(BuildContext context) {
    final List<String>? keywords = query
        ?.split(Unicode.halfWidthSpace)
        .map((String keyword) => keyword.toLowerCase())
        .toList();

    final Color keywordsBackgroundColor =
        (context.isDarkTheme ? AppColors.yellowDark : AppColors.yellow)
            .withOpacity(0.2);

    return RichText(
      textScaler: context.mqTextScaler,
      text: TextSpan(
        style: textStyle,
        children: prefixesChildren
          ..addAll(
            <InlineSpan>[
              if (keywords?.isEmpty ?? true)
                TextSpan(
                  text: HTMLParseUtils.unescapeHTML(title) ??
                      S.of(context).unknown,
                )
              else
                ...HTMLParseUtils.parseSearchResultArticleTile(title)
                        ?.map((String word) {
                      final bool isKeywords =
                          keywords!.contains(word.toLowerCase());

                      return TextSpan(
                        text: word,
                        style: isKeywords
                            ? TextStyle(
                                backgroundColor: keywordsBackgroundColor,
                                color: context.theme.colorScheme.error,
                              )
                            : null,
                      );
                    }) ??
                    <InlineSpan>[],
            ],
          ),
      ),
    );
  }
}
