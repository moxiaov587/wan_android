part of 'models.dart';

@Collection(accessor: 'accountCaches')
class AccountCache {
  @Index(unique: true)
  late Id userId;

  late String username;

  String? password;

  late DateTime updateTime;
}
