import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    Key? key,
    required this.uri,
  }) : super(key: key);

  final String uri;

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.uri),
      ),
      body: Center(
        child: Text('Article: ${widget.uri}'),
      ),
    );
  }
}
