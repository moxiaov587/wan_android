import 'package:flutter/material.dart';

import '../screen/article.dart';

class ArticlePage extends Page<void> {
  ArticlePage({required this.uri})
      : super(
          key: ValueKey<String>(uri),
        );

  final String uri;

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: this,
      builder: (BuildContext context) {
        return ArticleScreen(uri: uri);
      },
    );
  }
}
