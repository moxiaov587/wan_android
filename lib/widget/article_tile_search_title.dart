part of 'article.dart';

class ArticleTileSearchTitle extends StatelessWidget {
  const ArticleTileSearchTitle({
    super.key,
    required this.query,
    required this.title,
    required this.textStyle,
    this.prefixesChildren = const <InlineSpan>[],
  });

  final String query;
  final String title;
  final TextStyle textStyle;
  final List<InlineSpan> prefixesChildren;

  List<String> get keywords => query
      .split(Unicode.halfWidthSpace)
      .map((String keyword) => keyword.toLowerCase())
      .toList();

  List<String>? get words => HTMLParseUtils.parseSearchResultArticleTile(title);

  @override
  Widget build(BuildContext context) {
    final Color keywordsBackgroundColor =
        (context.isDarkTheme ? AppColors.yellowDark : AppColors.yellow)
            .withOpacity(0.2);

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: <InlineSpan>[
          ...prefixesChildren,
          ...words?.map((String word) {
                final bool isKeywords = keywords.contains(word.toLowerCase());

                return TextSpan(
                  text: word,
                  style: TextStyle(
                    backgroundColor:
                        isKeywords ? keywordsBackgroundColor : null,
                    color: isKeywords ? context.theme.colorScheme.error : null,
                  ),
                );
              }) ??
              <InlineSpan>[],
        ],
      ),
    );
  }
}
