part of 'api.dart';

extension AuthorizedAPI on Http {
  Future<UserModel> login({
    required String username,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.login,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!);
  }

  Future<UserModel> silentLogin({
    required String username,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await tokenDio.post<Map<String, dynamic>>(
      API.login,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<UserModel> register({
    required String username,
    required String password,
    required String repassword,
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.register,
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
        'repassword': repassword,
      },
      cancelToken: cancelToken,
    );

    return UserModel.fromJson(response.data!);
  }

  Future<void> logout() async {
    await dio.get<dynamic>(API.logout);
  }

  Future<UserInfoModel> fetchUserInfo({
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.post<Map<String, dynamic>>(
      API.userInfo,
      cancelToken: cancelToken,
    );

    return UserInfoModel.fromJson(response.data!);
  }

  Future<UserInfoModel> silentFetchUserInfo({
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await tokenDio.post<Map<String, dynamic>>(
      API.userInfo,
      cancelToken: cancelToken,
    );

    return UserInfoModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}
