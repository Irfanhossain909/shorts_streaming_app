import 'package:dartz/dartz.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/home/model/banner_model.dart';
import 'package:testemu/features/home/model/category_model.dart';
import 'package:testemu/features/home/model/movie_model.dart';
import 'package:testemu/features/home/model/remainder_model.dart';

class CategoryRepository {
  CategoryRepository._();
  // Api Service and Api End Point
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  // Category Repository Instance
  static final CategoryRepository _instance = CategoryRepository._();
  static CategoryRepository get instance => _instance;

  //--- Get Categories ---//

  Future<Either<String, List<Category>>> getCategories() async {
    try {
      final apiResponse = await apiService.get(apiEndPoint.getCategories);
      if (apiResponse.statusCode == 200) {
        final response = CategoryResponse.fromJson(
          apiResponse.data as Map<String, dynamic>,
        );
        final categories = response.data;
        return Right(categories);
      } else {
        errorLog(apiResponse.data, source: 'Category Repository');
        return Left(apiResponse.message);
      }
    } catch (e) {
      errorLog(e, source: 'Category Repository');
      return Left(e.toString());
    }
  }

  //--- Get Trailers ---//

  Future<Either<String, List<Trailer>>> getTrailers() async {
    try {
      final apiResponse = await apiService.get(apiEndPoint.getTrailers);
      if (apiResponse.statusCode == 200) {
        // The API returns the trailers wrapped in a top-level response object:
        // { success, message, statusCode, data: { meta, result: [...] } }
        final response = TrailerResponse.fromJson(
          apiResponse.data as Map<String, dynamic>,
        );
        final trailers = response.data.result;
        return Right(trailers);
      } else {
        errorLog(apiResponse.data, source: 'Trailer Repository');
        return Left(apiResponse.message);
      }
    } catch (e) {
      errorLog(e, source: 'Trailer Repository');
      return Left(e.toString());
    }
  }

  //--- Get All Movies ---//

  Future<Either<String, List<Movie>>> getAllMovies() async {
    try {
      List<Movie> allMovies = [];
      int currentPage = 1;
      int totalPages = 1;

      // Fetch all pages
      while (currentPage <= totalPages) {
        final apiResponse = await apiService.get(
          apiEndPoint.getAllMovies,
          queryParameters: {
            'page': currentPage.toString(),
            'limit': '50', // Fetch 50 items per page for efficiency
          },
        );

        if (apiResponse.statusCode == 200) {
          final response = MovieResponse.fromJson(
            apiResponse.data as Map<String, dynamic>,
          );

          // Add movies from this page
          allMovies.addAll(response.data);

          // Update total pages from meta
          totalPages = response.meta.totalPage;

          // Move to next page
          currentPage++;
        } else {
          errorLog(apiResponse.data, source: 'Movie Repository');
          return Left(apiResponse.message);
        }
      }

      return Right(allMovies);
    } catch (e) {
      errorLog(e, source: 'Movie Repository');
      return Left(e.toString());
    }
  }

  //--- Get Reminders ---//

  Future<Either<String, List<Reminder>>> getReminders() async {
    try {
      final apiResponse = await apiService.get(apiEndPoint.getReminders);
      if (apiResponse.statusCode == 200) {
        final response = ReminderResponse.fromJson(
          apiResponse.data as Map<String, dynamic>,
        );
        final reminders = response.data;
        return Right(reminders);
      } else {
        errorLog(apiResponse.data, source: 'Reminder Repository');
        return Left(apiResponse.message);
      }
    } catch (e) {
      errorLog(e, source: 'Reminder Repository');
      return Left(e.toString());
    }
  }

  //--- Toggle Bookmark ---//

  Future<Either<String, void>> toggleBookmark(
    String referenceId,
    String referenceType,
  ) async {
    try {
      Map<String, String> body = {
        "referenceId": referenceId,
        "referenceType": referenceType,
      };
      final apiResponse = await apiService.post(
        apiEndPoint.toggleBookmark,
        body: body,
      );
      if (apiResponse.statusCode == 200) {
        return Right(null);
      } else {
        errorLog(apiResponse.data, source: 'Toggle Bookmark Repository');
        return Left(apiResponse.message);
      }
    } catch (e) {
      errorLog(e, source: 'Toggle Bookmark Repository');
      return Left(e.toString());
    }
  }
}
