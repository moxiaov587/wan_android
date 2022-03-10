class RouteName {
  const RouteName({
    required String title,
    String? location,
  })  : _title = title,
        _location = location ?? '/$title';

  final String _title;

  String get title => _title;

  final String _location;

  String get location => _location.toLowerCase();
}

class RouterName {
  RouterName._();

  static const String initialPath = '/';

  static const RouteName splash = RouteName(
    title: 'Splash',
  );

  static const RouteName home = RouteName(
    title: 'Home',
    location: initialPath,
  );

  static const RouteName square = RouteName(title: 'Square');

  static const RouteName qa = RouteName(
    title: 'QA',
  );

  static const RouteName project = RouteName(title: 'Project');

  static final RouteName projectType = RouteName(
    title: 'ProjectType',
    location: '${project.location}/type',
  );

  static const RouteName search = RouteName(title: 'Search');

  static final List<String> homeTabsPath = <String>[
    home.location,
    square.location,
    qa.location,
    project.location,
  ];

  static final List<String> homePath = <String>[
    projectType.location,
    search.location,
  ];

  static const RouteName article = RouteName(
    title: 'Article',
    location: '/article/:id',
  );

  static const RouteName login = RouteName(
    title: 'Login',
  );

  static const RouteName register = RouteName(
    title: 'Register',
  );

  static const RouteName settings = RouteName(
    title: 'Settings',
  );

  static final RouteName languages = RouteName(
    title: 'Languages',
    location: '${settings.location}/languages',
  );

  static const RouteName rank = RouteName(
    title: 'Rank',
  );

  static const RouteName myPoints = RouteName(
    title: 'MyPoints',
  );

  static const RouteName myCollections = RouteName(
    title: 'MyCollections',
  );

  static final RouteName myArticleCollections = RouteName(
    title: 'MyArticleCollections',
    location: '${myCollections.location}/articles',
  );

  static final RouteName myWebsiteCollections = RouteName(
    title: 'MyWebsiteCollections',
    location: '${myCollections.location}/websites',
  );

  static final List<String> myCollectionsTabsPath = <String>[
    myArticleCollections.location,
    myWebsiteCollections.location,
  ];

  static final RouteName addArticlesToCollect = RouteName(
    title: 'AddArticlesToCollect',
    location: '${myArticleCollections.location}/add',
  );

  static final RouteName addWebsitesToCollect = RouteName(
    title: 'AddWebsitesToCollect',
    location: '${myWebsiteCollections.location}/add',
  );

  static final RouteName editArticlesInCollect = RouteName(
    title: 'EditArticlesInCollect',
    location: '${myArticleCollections.location}/edit/:id',
  );

  static final RouteName editWebsitesInCollect = RouteName(
    title: 'EditWebsitesInCollect',
    location: '${myWebsiteCollections.location}/edit/:id',
  );

  static const RouteName myShare = RouteName(
    title: 'MyShare',
  );

  static final RouteName addSharedArticle = RouteName(
    title: 'AddSharedArticle',
    location: '${myShare.location}/add',
  );

  static const RouteName theyShare = RouteName(
    title: 'TheyShare',
    location: 'theyshare/:id',
  );

  static const RouteName theyArticles = RouteName(
    title: 'TheyArticles',
    location: 'theyarticles/:author',
  );

  static const RouteName about = RouteName(
    title: 'About',
  );

  static final List<String> homeDrawerPath = <String>[
    myPoints.location,
    myCollections.location,
    myShare.location,
  ];

  static final List<RouteName> homeDrawerTiles = <RouteName>[
    myPoints,
    myCollections,
    myShare,
    about,
  ];

  static const RouteName unknown = RouteName(
    title: 'Unknown',
  );
}
