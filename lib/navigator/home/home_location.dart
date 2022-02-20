part of '../locations.dart';

class HomeLocation extends BeamLocation<HomeState> {
  RouteName getHandleCollectedBottomSheetRouterName({
    int? collectionTypeIndex,
    int? collectId,
  }) {
    final CollectionType type = CollectionType.values[collectionTypeIndex ?? 0];

    final bool isEdit = collectId != null;

    switch (type) {
      case CollectionType.article:
        if (isEdit) {
          return RouterName.editArticlesInCollect;
        }
        return RouterName.addArticlesToCollect;
      case CollectionType.website:
        if (isEdit) {
          return RouterName.editWebsitesInCollect;
        }
        return RouterName.addWebsitesToCollect;
    }
  }

  @override
  HomeState createState(RouteInformation routeInformation) =>
      HomeState().fromRouteInformation(routeInformation);

  @override
  void initState() {
    super.initState();
    state.addListener(notifyListeners);
  }

  @override
  void updateState(RouteInformation routeInformation) {
    final HomeState homeState =
        HomeState().fromRouteInformation(routeInformation);
    LogUtils.d('$runtimeType update state: path = $homeState');

    // state.updateWith(
    //   initialPath: homeState.initialPath,
    //   showProjectTypeBottomSheet: homeState.showProjectTypeBottomSheet,
    //   showSearch: homeState.showSearch,
    //   isLogin: homeState.isLogin,
    //   isRegister: homeState.isRegister,
    //   isAbout: homeState.isAbout,
    //   isRank: homeState.isRank,
    //   isSettings: homeState.isSettings,
    //   isLanguages: homeState.isLanguages,
    //   isMyCollections: homeState.isMyCollections,
    //   collectionTypeIndex: homeState.collectionTypeIndex,
    //   showHandleCollectedBottomSheet: homeState.showHandleCollectedBottomSheet,
    //   collectId: homeState.collectId,
    //   isMyPoints: homeState.isMyPoints,
    //   isMyShare: homeState.isMyShare,
    //   articleId: homeState.articleId,
    //   showSplash: homeState.showSplash,
    //   isUnknown: homeState.isUnknown,
    // );
  }

  @override
  void disposeState() {
    state.removeListener(notifyListeners);
    super.disposeState();
  }

  @override
  List<Pattern> get pathPatterns => <Pattern>['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, HomeState state) {
    LogUtils.d('$runtimeType build pages: state = $state');

    final RouteName handleCollectedBottomSheetRouterName =
        getHandleCollectedBottomSheetRouterName(
      collectionTypeIndex: state.collectionTypeIndex,
      collectId: state.collectId,
    );

    return state.showSplash
        ? <BeamPage>[
            BeamPage(
              key: ValueKey<String>(RouterName.splash.location),
              title: RouterName.splash.title,
              child: const SplashScreen(),
              onPopPage: (
                _,
                __,
                RouteInformationSerializable<dynamic> state,
                ___,
              ) {
                (state as HomeState).updateWith(
                  isUnknown: false,
                );

                return true;
              },
            ),
          ]
        : <BeamPage>[
            BeamPage(
              key: ValueKey<String>(RouterName.home.location),
              title: RouterName.home.title,
              child: HomeScreen(
                initialPath: state.initialPath,
              ),
            ),
            if (state.showProjectTypeBottomSheet)
              BeamPage(
                key: ValueKey<String>(RouterName.projectType.location),
                title: RouterName.projectType.title,
                routeBuilder: (BuildContext context, RouteSettings settings,
                    Widget child) {
                  const Radius radius = Radius.circular(20);

                  return ModalBottomSheetRoute<void>(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                      ),
                    ),
                    builder: (_) => child,
                    settings: settings,
                    capturedThemes: InheritedTheme.capture(
                      from: context,
                      to: Beamer.of(context).navigator.context,
                    ),
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                  );
                },
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showProjectTypeBottomSheet: false,
                  );

                  return true;
                },
                child: const ProjectTypeBottomSheet(),
              ),
            if (state.showSearch)
              BeamPage(
                key: ValueKey<String>(RouterName.search.location),
                title: RouterName.search.title,
                routeBuilder: (_, RouteSettings settings, Widget child) {
                  return SearchPageRoute<void>(
                    delegate: HomeSearchDelegate(),
                    settings: settings,
                  );
                },
                child: const SizedBox.shrink(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showSearch: false,
                  );

                  return true;
                },
              ),
            if (state.isAbout)
              BeamPage(
                key: ValueKey<String>(RouterName.about.location),
                title: RouterName.about.title,
                child: const AboutScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isAbout: false,
                  );

                  return true;
                },
              ),
            if (state.isRank)
              BeamPage(
                key: ValueKey<String>(RouterName.rank.location),
                title: RouterName.rank.title,
                child: const RankScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isRank: false,
                  );

                  return true;
                },
              ),
            if (state.isSettings)
              BeamPage(
                key: ValueKey<String>(RouterName.settings.location),
                title: RouterName.settings.title,
                child: const SettingsScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isSettings: false,
                  );

                  return true;
                },
              ),
            if (state.isLanguages)
              BeamPage(
                key: ValueKey<String>(RouterName.languages.location),
                title: RouterName.languages.title,
                child: const LanguagesScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isLanguages: false,
                  );

                  return true;
                },
              ),
            if (state.isMyCollections)
              BeamPage(
                key: ValueKey<String>(RouterName.myCollections.location),
                title: RouterName.myCollections.title,
                child: MyCollectionsScreen(
                  type: CollectionType.values[state.collectionTypeIndex ?? 0],
                ),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyCollections: false,
                    collectionTypeIndex: -1,
                  );

                  return true;
                },
              ),
            if (state.showHandleCollectedBottomSheet)
              BeamPage(
                key: ValueKey<String>(
                    handleCollectedBottomSheetRouterName.location),
                title: handleCollectedBottomSheetRouterName.title,
                routeBuilder: (BuildContext context, RouteSettings settings,
                    Widget child) {
                  const Radius radius = Radius.circular(20);

                  return ModalBottomSheetRoute<void>(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                      ),
                    ),
                    isScrollControlled: true,
                    constraints: BoxConstraints.tightFor(
                      height: ScreenUtils.height * .85,
                    ),
                    builder: (_) => child,
                    settings: settings,
                    capturedThemes: InheritedTheme.capture(
                      from: context,
                      to: Beamer.of(context).navigator.context,
                    ),
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                  );
                },
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showHandleCollectedBottomSheet: false,
                    collectId: -1,
                  );

                  return true;
                },
                child: HandleCollectedBottomSheet(
                  type: CollectionType.values[state.collectionTypeIndex ?? 0],
                  collectId: state.collectId,
                ),
              ),
            if (state.isMyPoints)
              BeamPage(
                key: ValueKey<String>(RouterName.myPoints.location),
                title: RouterName.myPoints.title,
                child: const MyPointsScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyPoints: false,
                  );

                  return true;
                },
              ),
            if (state.isMyShare)
              BeamPage(
                key: ValueKey<String>(RouterName.myShare.location),
                title: RouterName.myShare.title,
                child: const MyShareScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isMyShare: false,
                  );

                  return true;
                },
              ),
            if (state.showHandleSharedBottomSheet)
              BeamPage(
                key: ValueKey<String>(RouterName.addSharedArticle.location),
                title: RouterName.addSharedArticle.title,
                routeBuilder: (BuildContext context, RouteSettings settings,
                    Widget child) {
                  const Radius radius = Radius.circular(20);

                  return ModalBottomSheetRoute<void>(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: radius,
                        topRight: radius,
                      ),
                    ),
                    isScrollControlled: true,
                    constraints: BoxConstraints.tightFor(
                      height: ScreenUtils.height * .8,
                    ),
                    builder: (_) => child,
                    settings: settings,
                    capturedThemes: InheritedTheme.capture(
                      from: context,
                      to: Beamer.of(context).navigator.context,
                    ),
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                  );
                },
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    showHandleSharedBottomSheet: false,
                  );

                  return true;
                },
                child: const HandleSharedBottomSheet(),
              ),
            if (state.isTheyShare)
              BeamPage(
                key: ValueKey<String>(
                    '/${RouterName.theyShare.title.toLowerCase()}/${state.userId}'),
                title: RouterName.theyShare.title,
                child: TheyShareScreen(
                  userId: state.userId!,
                ),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    userId: -1,
                  );

                  return true;
                },
              ),
            if (state.isTheyArticles)
              BeamPage(
                key: ValueKey<String>(
                    '/${RouterName.theyArticles.title.toLowerCase()}/${state.author}'),
                title: RouterName.theyArticles.title,
                child: TheyArticlesScreen(
                  author: state.author!,
                ),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    author: '',
                  );

                  return true;
                },
              ),
            if (state.isArticle)
              BeamPage(
                key: ValueKey<String>(
                    '/${RouterName.article.title.toLowerCase()}/${state.articleId}'),
                title: RouterName.article.title,
                child: ArticleScreen(
                  id: state.articleId!,
                ),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    articleId: -1,
                  );

                  return true;
                },
              ),
            if (state.isLogin)
              BeamPage(
                key: ValueKey<String>(RouterName.login.location),
                title: RouterName.login.title,
                child: const LoginScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isLogin: false,
                  );

                  return true;
                },
              ),
            if (state.isRegister)
              BeamPage(
                key: ValueKey<String>(RouterName.register.location),
                title: RouterName.register.title,
                child: const RegisterScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isRegister: false,
                  );

                  return true;
                },
              ),
            if (state.isUnknown)
              BeamPage(
                key: ValueKey<String>(RouterName.unknown.location),
                title: RouterName.unknown.title,
                child: const UnknownScreen(),
                onPopPage: (
                  _,
                  __,
                  RouteInformationSerializable<dynamic> state,
                  ___,
                ) {
                  (state as HomeState).updateWith(
                    isUnknown: false,
                  );

                  return true;
                },
              ),
          ];
  }
}
