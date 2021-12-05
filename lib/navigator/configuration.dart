class Configuration {
  Configuration.home()
      : isUnknown = false,
        uri = null;

  Configuration.article({required this.uri}) : isUnknown = false;

  Configuration.unknown()
      : isUnknown = true,
        uri = null;

  final bool isUnknown;
  final String? uri;

  bool get isHome => uri == null;

  bool get isArticle => uri != null;
}
