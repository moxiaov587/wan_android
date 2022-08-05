import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';

import '../extensions/extensions.dart' show StringExtension;

class HTMLParseUtils {
  HTMLParseUtils._();

  static String? unescapeHTML(String? text) => text.strictValue == null
      ? null
      : HtmlUnescape().convert(text.strictValue!);

  static List<String>? parseSearchResultArticleTile(String? title) =>
      parse(title.strictValue)
          .body
          ?.nodes
          .map<String?>((Node node) => node.text)
          .whereType<String>()
          .toList();
}
