class API {
  const API._();

  static const String banner = '/banner/json';

  static const String topArticle = '/article/top/json';

  static String article({required int pageNum}) =>
      '/article/list/$pageNum/json';

  static String square({required int pageNum}) =>
      '/user_article/list/$pageNum/json';

  static String qa({required int pageNum}) => '/wenda/list/$pageNum/json';

  static String projectType = '/project/tree/json';

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
}
