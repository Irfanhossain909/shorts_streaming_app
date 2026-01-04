import 'package:dartz/dartz.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/my_list/model/my_list_model.dart';

class MyListRepository {
  MyListRepository._();
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  static final MyListRepository _instance = MyListRepository._();
  static MyListRepository get instance => _instance;

  Future<Either<String, List<Bookmark>>> getBookmarks() async {
    try {
      final apiResponse = await apiService.get(apiEndPoint.getBookmarks);
      if (apiResponse.statusCode == 200) {
        final response = BookmarkResponse.fromJson(
          apiResponse.data as Map<String, dynamic>,
        );
        final bookmarks = response.data;
        return Right(bookmarks);
      }
      errorLog(apiResponse.data, source: 'My List Repository');
      return Left(apiResponse.message);
    } catch (e) {
      errorLog(e, source: 'My List Repository');
      return Left(e.toString());
    }
  }
}
