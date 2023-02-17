part of 'api.dart';

extension OtherAPI on Http {
  Future<List<BannerModel>> fetchHomeBanners({
    CancelToken? cancelToken,
  }) async {
    final Response<List<dynamic>> response = await dio.get(
      API.banner,
      cancelToken: cancelToken,
      options: Options(
        extra: buildMethodGetCacheOptionsExtra(
          needCache: true,
          isDiskCache: true,
        ),
      ),
    );

    return response.data!
        .map((dynamic e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaginationData<UserPointsModel>> fetchPointsRank(
    int pageNum, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.pointsRank(pageNum: pageNum),
      cancelToken: cancelToken,
      options: Options(
        extra: buildMethodGetCacheOptionsExtra(
          needCache: true,
          isDiskCache: true,
        ),
      ),
    );

    return PaginationData<UserPointsModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return UserPointsModel.fromJson(obj);
        }

        return UserPointsModel(userId: -1);
      },
    );
  }
}
