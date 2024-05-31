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
  bool isSearching = false;
  String searchQuery = '';
  List<String> _favoriteArticles = [];

  List<Articles> get articles => _articles;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  List<String> get favoriteArticles => _favoriteArticles;

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

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _favoriteArticles = prefs?.getStringList('favorites') ?? [];
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

  void toggleFavorite(String title) {
    if (_favoriteArticles.contains(title)) {
      _favoriteArticles.remove(title);
    } else {
      _favoriteArticles.add(title);
    }
    prefs?.setStringList('favorites', _favoriteArticles);
    notifyListeners();
  }



  bool isFavorite(String title) {
    return _favoriteArticles.contains(title);
  }

  List<Articles> getFavoriteArticles() {
    return _articles.where((article) => _favoriteArticles.contains(article.title)).toList();
  }
}
