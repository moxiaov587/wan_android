part of '../locations.dart';

class HomeState extends ChangeNotifier
    with RouteInformationSerializable<HomeState> {
  HomeState({
    String initialPath = RouterName.initialPath,
    bool showProjectTypeBottomSheet = false,
    bool showSearch = false,
    bool isLogin = false,
    bool isRegister = false,
    bool isAbout = false,
    bool isRank = false,
    bool isSettings = false,
    bool isLanguages = false,
    bool isMyCollections = false,
    int? collectionTypeIndex,
    bool showHandleCollectedBottomSheet = false,
    int? collectId,
    bool isMyPoints = false,
    bool isMyShare = false,
    bool showHandleSharedBottomSheet = false,
    int? userId,
    String? author,
    int? articleId,
    bool showSplash = false,
    bool isUnknown = false,
  })  : _initialPath = initialPath,
        _showProjectTypeBottomSheet = showProjectTypeBottomSheet,
        _showSearch = showSearch,
        _isLogin = isLogin,
        _isRegister = isRegister,
        _isAbout = isAbout,
        _isRank = isRank,
        _isSettings = isSettings,
        _isLanguages = isLanguages,
        _isMyCollections = isMyCollections,
        _collectionTypeIndex = collectionTypeIndex,
        _showHandleCollectedBottomSheet = showHandleCollectedBottomSheet,
        _collectId = collectId,
        _isMyPoints = isMyPoints,
        _isMyShare = isMyShare,
        _showHandleSharedBottomSheet = showHandleSharedBottomSheet,
        _userId = userId,
        _author = author,
        _articleId = articleId,
        _showSplash = showSplash,
        _isUnknown = isUnknown;

  factory HomeState.fromJson(Map<String, dynamic> json) {
    return HomeState(
      initialPath: json['initialPath'] as String? ?? RouterName.initialPath,
      showProjectTypeBottomSheet:
          json['showProjectTypeBottomSheet'] as bool? ?? false,
      showSearch: json['showSearch'] as bool? ?? false,
      isLogin: json['isLogin'] as bool? ?? false,
      isRegister: json['isRegister'] as bool? ?? false,
      isAbout: json['isAbout'] as bool? ?? false,
      isRank: json['isRank'] as bool? ?? false,
      isSettings: json['isSettings'] as bool? ?? false,
      isLanguages: json['isLanguages'] as bool? ?? false,
      isMyCollections: json['isMyCollections'] as bool? ?? false,
      collectionTypeIndex: json['collectionTypeIndex'] as int?,
      showHandleCollectedBottomSheet:
          json['showHandleCollectedBottomSheet'] as bool? ?? false,
      collectId: json['collectId'] as int?,
      isMyPoints: json['isMyPoints'] as bool? ?? false,
      isMyShare: json['isMyShare'] as bool? ?? false,
      showHandleSharedBottomSheet:
          json['showHandleSharedBottomSheet'] as bool? ?? false,
      userId: json['userId'] as int?,
      author: json['author'] as String?,
      articleId: json['articleId'] as int?,
      showSplash: json['showSplash'] as bool? ?? false,
      isUnknown: json['isUnknown'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'initialPath': _initialPath,
        'showProjectTypeBottomSheet': _showProjectTypeBottomSheet,
        'showSearch': _showSearch,
        'isLogin': _isLogin,
        'isRegister': _isRegister,
        'isAbout': _isAbout,
        'isRank': _isRank,
        'isSettings': _isSettings,
        'isLanguages': _isLanguages,
        'isMyCollections': _isMyCollections,
        'collectionTypeIndex': _collectionTypeIndex,
        'showHandleCollectedBottomSheet': _showHandleCollectedBottomSheet,
        'collectId': _collectId,
        'isMyPoints': _isMyPoints,
        'isMyShare': _isMyShare,
        'showHandleSharedBottomSheet': _showHandleSharedBottomSheet,
        'userId': _userId,
        'author': _author,
        'articleId': _articleId,
        'showSplash': _showSplash,
        'isUnknown': _isUnknown,
      };

  String _initialPath;
  String get initialPath => _initialPath;

  bool _showProjectTypeBottomSheet;
  bool get showProjectTypeBottomSheet => _showProjectTypeBottomSheet;

  bool _showSearch;
  bool get showSearch => _showSearch;

  bool _isLogin;
  bool get isLogin => _isLogin;

  bool _isRegister;
  bool get isRegister => _isRegister;

  bool _isAbout;
  bool get isAbout => _isAbout;

  bool _isRank;
  bool get isRank => _isRank;

  bool _isSettings;
  bool get isSettings => _isSettings;

  bool _isLanguages;
  bool get isLanguages => _isLanguages;

  bool _isMyCollections;
  bool get isMyCollections => _isMyCollections;

  int? _collectionTypeIndex;
  int? get collectionTypeIndex => _collectionTypeIndex;

  bool _showHandleCollectedBottomSheet;
  bool get showHandleCollectedBottomSheet => _showHandleCollectedBottomSheet;

  int? _collectId;
  int? get collectId => _collectId;

  bool _isMyPoints;
  bool get isMyPoints => _isMyPoints;

  bool _isMyShare;
  bool get isMyShare => _isMyShare;

  bool _showHandleSharedBottomSheet;
  bool get showHandleSharedBottomSheet => _showHandleSharedBottomSheet;

  int? _userId;
  int? get userId => _userId;

  bool get isTheyShare => _userId != null;

  String? _author;
  String? get author => _author;

  bool get isTheyArticles => _author != null;

  int? _articleId;
  int? get articleId => _articleId;

  bool get isArticle => _articleId != null;

  bool _showSplash;
  bool get showSplash => _showSplash;

  bool _isUnknown;
  bool get isUnknown => _isUnknown;

  void updateWith({
    String? initialPath,
    bool? showProjectTypeBottomSheet,
    bool? showSearch,
    bool? isLogin,
    bool? isRegister,
    bool? isAbout,
    bool? isRank,
    bool? isSettings,
    bool? isLanguages,
    bool? isMyCollections,
    int? collectionTypeIndex,
    bool? showHandleCollectedBottomSheet,
    int? collectId,
    bool? isMyPoints,
    bool? isMyShare,
    bool? showHandleSharedBottomSheet,
    int? userId,
    String? author,
    int? articleId,
    bool? showSplash,
    bool? isUnknown,
    bool rebuild = true,
  }) {
    if (initialPath != null) {
      _initialPath = initialPath;
    }

    if (showProjectTypeBottomSheet != null) {
      _showProjectTypeBottomSheet = showProjectTypeBottomSheet;
    }

    if (showSearch != null) {
      _showSearch = showSearch;
    }

    if (isLogin != null) {
      _isLogin = isLogin;
    }

    if (isRegister != null) {
      _isRegister = isRegister;
    }

    if (isAbout != null) {
      _isAbout = isAbout;
    }

    if (isRank != null) {
      _isRank = isRank;
    }

    if (isSettings != null) {
      _isSettings = isSettings;
    }

    if (isLanguages != null) {
      _isLanguages = isLanguages;
    }

    if (isMyCollections != null) {
      _isMyCollections = isMyCollections;
    }

    if (collectionTypeIndex != null) {
      _collectionTypeIndex =
          collectionTypeIndex == -1 ? null : collectionTypeIndex;
    }

    if (showHandleCollectedBottomSheet != null) {
      _showHandleCollectedBottomSheet = showHandleCollectedBottomSheet;
    }

    if (collectId != null) {
      _collectId = collectId == -1 ? null : collectId;
    }

    if (isMyPoints != null) {
      _isMyPoints = isMyPoints;
    }

    if (isMyShare != null) {
      _isMyShare = isMyShare;
    }

    if (showHandleSharedBottomSheet != null) {
      _showHandleSharedBottomSheet = showHandleSharedBottomSheet;
    }

    if (userId != null) {
      _userId = userId == -1 ? null : userId;
    }

    if (author != null) {
      _author = author.isEmpty ? null : author;
    }

    if (articleId != null) {
      _articleId = articleId == -1 ? null : articleId;
    }

    if (showSplash != null) {
      _showSplash = showSplash;
    }

    if (isUnknown != null) {
      _isUnknown = isUnknown;
    }

    if (rebuild) {
      notifyListeners();
    }
  }

  HomeState copyWith({
    String? initialPath,
    bool? showProjectTypeBottomSheet,
    bool? showSearch,
    bool? isLogin,
    bool? isRegister,
    bool? isAbout,
    bool? isRank,
    bool? isSettings,
    bool? isLanguages,
    bool? isMyCollections,
    int? collectionTypeIndex,
    bool? showHandleCollectedBottomSheet,
    int? collectId,
    bool? isMyPoints,
    bool? isMyShare,
    bool? showHandleSharedBottomSheet,
    int? userId,
    String? author,
    int? articleId,
    bool? showSplash,
    bool? isUnknown,
  }) {
    return HomeState(
      initialPath: initialPath ?? _initialPath,
      showProjectTypeBottomSheet:
          showProjectTypeBottomSheet ?? _showProjectTypeBottomSheet,
      showSearch: showSearch ?? _showSearch,
      isLogin: isLogin ?? _isLogin,
      isRegister: isRegister ?? _isRegister,
      isAbout: isAbout ?? _isAbout,
      isRank: isRank ?? _isRank,
      isSettings: isSettings ?? _isSettings,
      isLanguages: isLanguages ?? _isLanguages,
      isMyCollections: isMyCollections ?? _isMyCollections,
      collectionTypeIndex: collectionTypeIndex ?? _collectionTypeIndex,
      showHandleCollectedBottomSheet:
          showHandleCollectedBottomSheet ?? _showHandleCollectedBottomSheet,
      collectId: collectId ?? _collectId,
      isMyPoints: isMyPoints ?? _isMyPoints,
      isMyShare: isMyShare ?? _isMyShare,
      showHandleSharedBottomSheet:
          showHandleSharedBottomSheet ?? _showHandleSharedBottomSheet,
      userId: userId ?? _userId,
      author: author ?? _author,
      articleId: articleId ?? _articleId,
      showSplash: showSplash ?? _showSplash,
      isUnknown: isUnknown ?? _isUnknown,
    );
  }

  @override
  HomeState fromRouteInformation(RouteInformation routeInformation) {
    final Uri uri =
        Uri.parse(routeInformation.location ?? RouterName.home.location);

    LogUtils.d('from routeInformation : $uri');

    final String uriString = uri.toString();

    final HomeState homeState = HomeState.fromJson(
        routeInformation.state as Map<String, dynamic>? ?? <String, dynamic>{});

    if (RouterName.homeTabsPath.contains(uriString)) {
      return homeState.copyWith(
        initialPath: uriString,
      );
    }

    if (uriString == RouterName.search.location) {
      return homeState.copyWith(
        showSearch: true,
      );
    }

    if (uriString == RouterName.projectType.location) {
      return homeState.copyWith(
        initialPath: RouterName.project.location,
        showProjectTypeBottomSheet: true,
      );
    }

    if (uri.pathSegments.first == RouterName.article.title.toLowerCase() &&
        uri.pathSegments.contains('id')) {
      return homeState.copyWith(
        articleId: uri.pathSegments.last as int,
      );
    }

    if (uri.pathSegments.first == RouterName.theyShare.title.toLowerCase() &&
        uri.pathSegments.contains('id')) {
      return homeState.copyWith(
        userId: uri.pathSegments.last as int,
      );
    }

    if (uri.pathSegments.first == RouterName.theyArticles.title.toLowerCase() &&
        uri.pathSegments.contains('author')) {
      return homeState.copyWith(
        author: uri.pathSegments.last,
      );
    }

    if (uriString == RouterName.login.location) {
      return homeState.copyWith(
        isLogin: true,
      );
    }

    if (uriString == RouterName.register.location) {
      return homeState.copyWith(
        isRegister: true,
      );
    }

    if (uriString == RouterName.about.location) {
      return homeState.copyWith(
        isAbout: true,
      );
    }

    if (uriString == RouterName.rank.location) {
      return homeState.copyWith(
        isRank: true,
      );
    }

    if (uriString == RouterName.settings.location) {
      return homeState.copyWith(
        isSettings: true,
      );
    }

    if (uriString == RouterName.languages.location) {
      return homeState.copyWith(
        isLanguages: true,
      );
    }

    if (uriString == RouterName.myCollections.location) {
      return homeState.copyWith(
        isMyCollections: true,
        collectionTypeIndex: CollectionType.values.first.index,
      );
    }

    if (uriString == RouterName.myArticleCollections.location) {
      return homeState.copyWith(
        isMyCollections: true,
        collectionTypeIndex: CollectionType.article.index,
      );
    }

    if (uriString == RouterName.myWebsiteCollections.location) {
      return homeState.copyWith(
        isMyCollections: true,
        collectionTypeIndex: CollectionType.website.index,
      );
    }

    if (uriString == RouterName.addArticlesToCollect.location) {
      return homeState.copyWith(
        isMyCollections: true,
        collectionTypeIndex: CollectionType.article.index,
        showHandleCollectedBottomSheet: true,
      );
    }

    if (uriString == RouterName.addWebsitesToCollect.location) {
      return homeState.copyWith(
        isMyCollections: true,
        collectionTypeIndex: CollectionType.website.index,
        showHandleCollectedBottomSheet: true,
      );
    }

    if (uriString.contains(RouterName.myArticleCollections.location) &&
        uri.pathSegments.contains('edit') &&
        uri.pathSegments.contains('id')) {
      return homeState.copyWith(
          isMyCollections: true,
          collectionTypeIndex: CollectionType.article.index,
          showHandleCollectedBottomSheet: true,
          collectId: uri.pathSegments.last as int);
    }

    if (uriString.contains(RouterName.myWebsiteCollections.location) &&
        uri.pathSegments.contains('edit') &&
        uri.pathSegments.contains('id')) {
      return homeState.copyWith(
          isMyCollections: true,
          collectionTypeIndex: CollectionType.website.index,
          showHandleCollectedBottomSheet: true,
          collectId: uri.pathSegments.last as int);
    }

    if (uriString == RouterName.myPoints.location) {
      return homeState.copyWith(
        isMyPoints: true,
      );
    }

    if (uriString == RouterName.myShare.location) {
      return homeState.copyWith(
        isMyShare: true,
      );
    }

    if (uriString == RouterName.addSharedArticle.location) {
      return homeState.copyWith(
        isMyShare: true,
        showHandleSharedBottomSheet: true,
      );
    }

    if (uriString == RouterName.splash.location) {
      return homeState.copyWith(
        showSplash: true,
      );
    }

    return homeState.copyWith(
      isUnknown: true,
    );
  }

  @override
  RouteInformation toRouteInformation() {
    LogUtils.d('$runtimeType to routeInformation');

    /// The order here should be reversed from the Location [buildPages]
    if (showSplash) {
      return RouteInformation(
        location: RouterName.splash.location,
        state: toJson(),
      );
    }

    if (isUnknown) {
      return RouteInformation(
        location: RouterName.unknown.location,
        state: toJson(),
      );
    }

    if (isRegister) {
      return RouteInformation(
        location: RouterName.register.location,
        state: toJson(),
      );
    }

    if (isLogin) {
      return RouteInformation(
        location: RouterName.login.location,
        state: toJson(),
      );
    }

    if (isArticle) {
      return RouteInformation(
        location: '/${RouterName.article.title.toLowerCase()}/$_articleId',
        state: toJson(),
      );
    }

    if (isTheyShare) {
      return RouteInformation(
        location: '/${RouterName.theyShare.title.toLowerCase()}/$_userId',
        state: toJson(),
      );
    }

    if (isTheyArticles) {
      return RouteInformation(
        location: '/${RouterName.theyArticles.title.toLowerCase()}/$_author',
        state: toJson(),
      );
    }

    if (isAbout) {
      return RouteInformation(
        location: RouterName.about.location,
        state: toJson(),
      );
    }

    if (isRank) {
      return RouteInformation(
        location: RouterName.rank.location,
        state: toJson(),
      );
    }

    if (isSettings) {
      return RouteInformation(
        location: RouterName.settings.location,
        state: toJson(),
      );
    }

    if (isLanguages) {
      return RouteInformation(
        location: RouterName.languages.location,
        state: toJson(),
      );
    }

    if (isMyCollections) {
      if (collectionTypeIndex == CollectionType.article.index) {
        if (showHandleCollectedBottomSheet) {
          if (collectId != null) {
            return RouteInformation(
              location: RouterName.editArticlesInCollect.location,
              state: toJson(),
            );
          }

          return RouteInformation(
            location: RouterName.addArticlesToCollect.location,
            state: toJson(),
          );
        }
        return RouteInformation(
          location: RouterName.myArticleCollections.location,
          state: toJson(),
        );
      }

      if (collectionTypeIndex == CollectionType.website.index) {
        if (showHandleCollectedBottomSheet) {
          if (collectId != null) {
            return RouteInformation(
              location: RouterName.editWebsitesInCollect.location,
              state: toJson(),
            );
          }

          return RouteInformation(
            location: RouterName.addWebsitesToCollect.location,
            state: toJson(),
          );
        }
        return RouteInformation(
          location: RouterName.myWebsiteCollections.location,
          state: toJson(),
        );
      }

      return RouteInformation(
        location: RouterName.myCollections.location,
        state: toJson(),
      );
    }

    if (isMyPoints) {
      return RouteInformation(
        location: RouterName.myPoints.location,
        state: toJson(),
      );
    }

    if (showHandleSharedBottomSheet) {
      return RouteInformation(
        location: RouterName.addSharedArticle.location,
        state: toJson(),
      );
    }

    if (isMyShare) {
      return RouteInformation(
        location: RouterName.myShare.location,
        state: toJson(),
      );
    }

    if (showProjectTypeBottomSheet) {
      return RouteInformation(
        location: RouterName.projectType.location,
        state: toJson(),
      );
    }

    if (showSearch) {
      return RouteInformation(
        location: RouterName.search.location,
        state: toJson(),
      );
    }

    return RouteInformation(
      location: initialPath,
      state: toJson(),
    );
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
