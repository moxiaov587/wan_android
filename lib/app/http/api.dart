class API {
  const API._();

  static const String banner = '/banner/json';

  static const String topArticle = '/article/top/json';

  static String article({required int pageNum}) =>
      '/article/list/$pageNum/json';
}
