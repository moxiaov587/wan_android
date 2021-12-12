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
    @Default('') String apkLink,
    @Default(0) int audit,
    @Default('') String author,
    @Default(false) bool canEdit,
    @Default(0) int chapterId,
    @Default('') String chapterName,
    @Default(false) bool collect,
    @Default(0) int courseId,
    @Default('') String desc,
    @Default('') String descMd,
    @Default('') String envelopePic,
    @Default(false) bool fresh,
    @Default('') String host,
    @Default(0) int id,
    @Default('') String link,
    @Default('') String niceDate,
    @Default('') String niceShareDate,
    @Default('') String origin,
    @Default('') String prefix,
    @Default('') String projectLink,
    @Default(0) int publishTime,
    @Default(0) int realSuperChapterId,
    @Default(0) int selfVisible,
    @Default(0) int shareDate,
    @Default('') String shareUser,
    @Default(0) int superChapterId,
    @Default('') String superChapterName,
    @Default(<TagModel>[]) List<TagModel> tags,
    @Default('') String title,
    @Default(0) int type,
    @Default(0) int userId,
    @Default(0) int visible,
    @Default(0) int zan,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}

@freezed
class TagModel with _$TagModel {
  factory TagModel({
    @Default('') String name,
    @Default('') String url,
  }) = _TagModel;

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}
