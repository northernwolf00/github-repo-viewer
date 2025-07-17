import 'package:dio/dio.dart';


class GitHubApi {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchUserRepos(String username) async {
    try {
      final response = await _dio.get('https://api.github.com/users/$username/repos');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load repositories: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

