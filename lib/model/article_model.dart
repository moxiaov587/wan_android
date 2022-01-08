part of 'models.dart';

@freezed
class RefreshArticleListModel with _$RefreshArticleListModel {
  factory RefreshArticleListModel({
    /// [curPage] actually the page number of the next page
    @Default(0) int curPage,
    @Default(<ArticleModel>[]) List<ArticleModel> datas,
    @Default(20) int offset,
    @Default(false) bool over,
    @Default(0) int pageCount,
    @Default(20) int size,
    @Default(0) int total,
  }) = _RefreshArticleListModel;

  factory RefreshArticleListModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshArticleListModelFromJson(json);
}

@freezed
class ArticleModel with _$ArticleModel {
  factory ArticleModel({
    String? apkLink,
    int? audit,
    String? author,
    @Default(false) bool canEdit,
    int? chapterId,
    String? chapterName,
    @Default(false) bool collect,
    int? courseId,
    String? desc,
    String? descMd,
    String? envelopePic,
    @Default(false) bool fresh,
    String? host,
    required int id,
    required String link,
    String? niceDate,
    String? niceShareDate,
    String? origin,
    String? prefix,
    String? projectLink,
    int? publishTime,
    int? realSuperChapterId,
    int? selfVisible,
    int? shareDate,
    String? shareUser,
    int? superChapterId,
    String? superChapterName,
    List<TagModel>? tags,
    required String title,
    int? type,
    int? userId,
    int? visible,
    @Default(0) int zan,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}

@freezed
class TagModel with _$TagModel {
  factory TagModel({
    String? name,
    String? url,
  }) = _TagModel;

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}
