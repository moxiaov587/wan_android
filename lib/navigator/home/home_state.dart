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
    bool isMyPoints = false,
    bool isMyShare = false,
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
        _isMyPoints = isMyPoints,
        _isMyShare = isMyShare,
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
      isMyPoints: json['isMyPoints'] as bool? ?? false,
      isMyShare: json['isMyShare'] as bool? ?? false,
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
        'isMyPoints': _isMyPoints,
        'isMyShare': _isMyShare,
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

  bool _isMyPoints;
  bool get isMyPoints => _isMyPoints;

  bool _isMyShare;
  bool get isMyShare => _isMyShare;

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
    bool? isMyPoints,
    bool? isMyShare,
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

    if (isMyPoints != null) {
      _isMyPoints = isMyPoints;
    }

    if (isMyShare != null) {
      _isMyShare = isMyShare;
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
    bool? isMyPoints,
    bool? isMyShare,
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
      isMyPoints: isMyPoints ?? _isMyPoints,
      isMyShare: isMyShare ?? _isMyShare,
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
      );
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
