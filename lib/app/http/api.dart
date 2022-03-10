class API {
  const API._();

  static const String banner = '/banner/json';

  static const String topArticle = '/article/top/json';

  static String article({required int pageNum}) =>
      '/article/list/$pageNum/json';

  static String square({required int pageNum}) =>
      '/user_article/list/$pageNum/json';

  static String qa({required int pageNum}) => '/wenda/list/$pageNum/json';

  static const String projectType = '/project/tree/json';

  static String project({
    required int pageNum,
    required int categoryId,
  }) =>
      '/project/list/$pageNum/json?cid=$categoryId';

  static String search({required int pageNum}) =>
      '/article/query/$pageNum/json';

  static const String searchPopularKeywords = '/hotkey/json';

  static const String login = '/user/login';

  static const String register = '/user/register';

  static const String logout = '/user/logout/json';

  static const String userInfo = '/user/lg/userinfo/json';

  static String pointsRank({required int pageNum}) =>
      '/coin/rank/$pageNum/json';

  static String userPointsRecord({required int pageNum}) =>
      '/lg/coin/list/$pageNum/json';

  static String collectedArticles({required int pageNum}) =>
      '/lg/collect/list/$pageNum/json';

  static const String addCollectedArticle = '/lg/collect/add/json';

  static String updateCollectedArticle({required int collectId}) =>
      '/lg/collect/user_article/update/$collectId/json';

  static String addCollectedArticleByArticleId({required int articleId}) =>
      '/lg/collect/$articleId/json';

  static String deleteCollectedArticleByArticleId({required int articleId}) =>
      '/lg/uncollect_originId/$articleId/json';

  static String deleteCollectedArticleByCollectId({required int collectId}) =>
      '/lg/uncollect/$collectId/json';

  static const String collectedWebsites = '/lg/collect/usertools/json';

  static const String addCollectedWebsite = '/lg/collect/addtool/json';

  static const String updateCollectedWebsite = '/lg/collect/updatetool/json';

  static const String deleteCollectedWebsite = '/lg/collect/deletetool/json';

  static String shareArticle({required int pageNum}) =>
      '/user/lg/private_articles/$pageNum/json';

  static const String addShareArticle = '/lg/user_article/add/json';

  static String deleteShareArticle({required int articleId}) =>
      '/lg/user_article/delete/$articleId/json';

  static String shareArticleByUserId({
    required int userId,
    required int pageNum,
  }) =>
      '/user/$userId/share_articles/$pageNum/json';

  static String articleByAuthor({
    required String author,
    required int pageNum,
  }) =>
      '/article/list/$pageNum/json?author=$author';
}
