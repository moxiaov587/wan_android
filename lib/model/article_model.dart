import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';

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
    DateTime? niceDate,
    DateTime? niceShareDate,
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

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      apkLink: json['apkLink'] as String,
      audit: json['audit'] as int,
      author: json['author'] as String,
      canEdit: json['canEdit'] as bool,
      chapterId: json['chapterId'] as int,
      chapterName: json['chapterName'] as String,
      collect: json['collect'] as bool,
      courseId: json['courseId'] as int,
      desc: json['desc'] as String,
      descMd: json['descMd'] as String,
      envelopePic: json['envelopePic'] as String,
      fresh: json['fresh'] as bool,
      host: json['host'] as String,
      id: json['id'] as int,
      link: json['link'] as String,
      niceDate: DateTime.tryParse(json['niceDate'] as String),
      niceShareDate: DateTime.tryParse(json['niceShareDate'] as String),
      origin: json['origin'] as String,
      prefix: json['prefix'] as String,
      projectLink: json['projectLink'] as String,
      publishTime: json['publishTime'] as int,
      realSuperChapterId: json['realSuperChapterId'] as int,
      selfVisible: json['selfVisible'] as int,
      shareDate: json['shareDate'] as int,
      shareUser: json['shareUser'] as String,
      superChapterId: json['superChapterId'] as int,
      superChapterName: json['superChapterName'] as String,
      tags: (json['tags'] as List<dynamic>)
          .map((dynamic e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      type: json['type'] as int,
      userId: json['userId'] as int,
      visible: json['visible'] as int,
      zan: json['zan'] as int,
    );
  }

  static Map<String, dynamic> toJson(ArticleModel object) {
    return <String, dynamic>{
      'apkLink': object.apkLink,
      'audit': object.audit,
      'author': object.author,
      'canEdit': object.canEdit,
      'chapterId': object.chapterId,
      'chapterName': object.chapterName,
      'collect': object.collect,
      'courseId': object.courseId,
      'desc': object.desc,
      'descMd': object.descMd,
      'envelopePic': object.envelopePic,
      'fresh': object.fresh,
      'host': object.host,
      'id': object.id,
      'link': object.link,
      'niceDate': object.niceDate,
      'niceShareDate': object.niceShareDate,
      'origin': object.origin,
      'prefix': object.prefix,
      'projectLink': object.projectLink,
      'publishTime': object.publishTime,
      'realSuperChapterId': object.realSuperChapterId,
      'selfVisible': object.selfVisible,
      'shareDate': object.shareDate,
      'shareUser': object.shareUser,
      'superChapterId': object.superChapterId,
      'superChapterName': object.superChapterName,
      'tags': object.tags,
      'title': object.title,
      'type': object.type,
      'userId': object.userId,
      'visible': object.visible,
      'zan': object.zan,
    };
  }
}

@freezed
class TagModel with _$TagModel {
  factory TagModel({
    @Default('') String name,
    @Default('') String url,
  }) = _TagModel;

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  static Map<String, dynamic> toJson(TagModel object) {
    return <String, dynamic>{
      'name': object.name,
      'url': object.url,
    };
  }
}
