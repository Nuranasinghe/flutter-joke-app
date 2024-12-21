import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JokeService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchJokesRaw() async {
    try {
      final response = await _dio
          .get('https://v2.jokeapi.dev/joke/Any?amount=5&blacklistFlags=nsfw');

      if (response.statusCode == 200) {
        final List<dynamic> jokesJson = response.data['jokes'];
        return jokesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load jokes');
      }
    } catch (e) {
      throw Exception('Failed to load jokes: $e');
    }
  }

  Future<void> cacheJokes(List<Map<String, dynamic>> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = jsonEncode(jokes);
    await prefs.setString('cached_jokes', jokesJson);
  }

  Future<List<Map<String, dynamic>>> getCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = prefs.getString('cached_jokes');
    if (jokesJson != null) {
      final List<dynamic> jokesList = jsonDecode(jokesJson);
      return jokesList.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getJokes() async {
    try {
      final jokes = await fetchJokesRaw();
      await cacheJokes(jokes);
      return jokes;
    } catch (e) {
      print('Failed to fetch jokes, loading cached jokes...');
      return await getCachedJokes();
    }
  }
}
