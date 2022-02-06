import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

import '../extensions/extensions.dart' show StringExtension;

class HTMLParseUtils {
  HTMLParseUtils._();

  static String? parseArticleTitle({required String? title}) =>
      title.strictValue == null ? null : parse(title.strictValue).body?.text;

  static List<String>? parseSearchResultArticleTile({required String? title}) {
    if (title.strictValue == null) {
      return null;
    }

    final Element? body = parse(title.strictValue).body;

    if (body == null) {
      return null;
    }

    return body.nodes
        .map((Node node) => node.text)
        .whereType<String>()
        .toList();
  }
}
