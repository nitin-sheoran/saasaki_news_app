import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saasaki_news_app/news/model/news_model.dart';

class NewsApiService {
  final String apiKey = '0a7bdfe011a74df6b521cbddba406b33';

  Future<List<Articles>> fetchNews(String category, int page) async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/everything?q=$category&page=$page&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['articles'];
      List<Articles> articles = data.map((item) => Articles.fromJson(item)).toList();
      return articles;
    } else {
      throw Exception('Something went wrong');
    }
  }
}
