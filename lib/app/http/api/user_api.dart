part of 'api.dart';

extension UserAPI on Http {
  Future<PaginationData<PointsModel>> fetchUserPointsRecord(
    int pageNum,
    int pageSize, {
    CancelToken? cancelToken,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      API.userPointsRecord(pageNum: pageNum),
      queryParameters: <String, dynamic>{'page_size': pageSize},
      cancelToken: cancelToken,
    );

    return PaginationData<PointsModel>.fromJson(
      response.data!,
      (Object? obj) {
        if (obj is Map<String, dynamic>) {
          return PointsModel.fromJson(obj);
        }

        return PointsModel(coinCount: 0, id: -1);
      },
    );
  }
}
