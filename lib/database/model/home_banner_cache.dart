part of 'models.dart';

@Collection(accessor: 'homeBannerCaches')
class HomeBannerCache {
  @Index(unique: true)
  late Id id;

  late int isVisible;

  late int order;

  late int type;

  late String title;

  late String desc;

  late String url;

  late String imageUrl;

  late int? primaryColorValue;

  late int? textColorValue;
}
