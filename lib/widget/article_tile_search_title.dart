part of 'article.dart';

class ArticleTileSearchTitle extends StatelessWidget {
  const ArticleTileSearchTitle({
    super.key,
    required this.query,
    required this.title,
    required this.textStyle,
  });

  final String query;
  final String title;
  final TextStyle textStyle;

  List<String> get keywords => query
      .split(Unicode.halfWidthSpace)
      .map((String keyword) => keyword.toLowerCase())
      .toList();

  List<String>? get words =>
      HTMLParseUtils.parseSearchResultArticleTile(title: title);

  @override
  Widget build(BuildContext context) {
    final Color keywordsBackgroundColor =
        (currentIsDark ? AppColors.yellowDark : AppColors.yellow)
            .withOpacity(0.2);

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: words?.map((String word) {
          final bool isKeywords = keywords.contains(word.toLowerCase());

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
