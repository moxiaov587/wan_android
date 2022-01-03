part of 'models.dart';

@HiveType(typeId: HiveAdapterTypeIds.authorizedCache)
class AuthorizedCache extends HiveObject {
  AuthorizedCache({
    required this.id,
    required this.username,
    this.password,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String? password;
}
