import 'package:flutter/material.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/service/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider with ChangeNotifier {
  final NewsApiService newsApiService;

  NewsProvider({
    required this.newsApiService,
  });

  List<Articles> _articles = [];
  String _selectedCategory = 'general';
  bool _isLoading = false;
  SharedPreferences? prefs;
  int _currentPage = 1;
  bool isLoadingMore = false;

  List<Articles> get articles => _articles;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchNews({int page = 1}) async {
    if (page == 1) {
      _isLoading = true;
      notifyListeners();
    } else {
      isLoadingMore = true;
      notifyListeners();
    }

    List<Articles> fetchedArticles = await newsApiService.fetchNews(_selectedCategory, page);
    if (page == 1) {
      _articles = fetchedArticles;
    } else {
      _articles.addAll(fetchedArticles);
    }

    _isLoading = false;
    isLoadingMore = false;
    _currentPage = page;
    notifyListeners();
  }

  Future<void> fetchMoreNews() async {
    await fetchNews(page: _currentPage + 1);
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    _currentPage = 1;
    fetchNews();
  }
}
