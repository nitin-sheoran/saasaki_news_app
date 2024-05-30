// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:saasaki_news_app/news/model/news_model.dart';
// import 'package:saasaki_news_app/news/provider/news_provider.dart';
// import 'package:saasaki_news_app/news/ui/bookmark_news_screen.dart';
// import 'package:saasaki_news_app/news/ui/news_all_detail_screen.dart';
// import 'package:saasaki_news_app/news/utils/colors_const.dart';
// import 'package:saasaki_news_app/news/utils/string_const.dart';
//
// class NewsInformationScreen extends StatefulWidget {
//   const NewsInformationScreen({super.key});
//
//   @override
//   NewsScreen createState() => NewsScreen();
// }
//
// class NewsScreen extends State<NewsInformationScreen> {
//   late NewsProvider newsProvider;
//   late ScrollController _scrollController;
//   bool _isLoadingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     newsProvider = Provider.of<NewsProvider>(context, listen: false);
//     newsProvider.fetchNews();
//     newsProvider.initSharedPreferences();
//     _scrollController = ScrollController()..addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.extentAfter < 10 && !_isLoadingMore) {
//       setState(() {
//         _isLoadingMore = true;
//       });
//       newsProvider.fetchMoreNews().then((_) {
//         setState(() {
//           _isLoadingMore = false;
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: ColorsConst.whiteColor,
//       ),
//       child: Scaffold(
//         backgroundColor: ColorsConst.whiteColor,
//         appBar: AppBar(
//           backgroundColor: ColorsConst.blueColor,
//           automaticallyImplyLeading: false,
//           title: Text(
//             '${newsProvider.selectedCategory[0].toUpperCase()}${newsProvider.selectedCategory.substring(1)} News',
//             style: const TextStyle(color: Colors.white),
//           ),
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(14),
//                 bottomLeft: Radius.circular(14),
//               )),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 4),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                               const BookMarkNewsScreen()));
//                     },
//                     icon: const Icon(
//                       Icons.save,
//                       color: ColorsConst.whiteColor,
//                     ),
//                   ),
//                   PopupMenuButton<String>(
//                     icon: const Icon(
//                       Icons.filter_list_rounded,
//                       color: ColorsConst.whiteColor,
//                     ),
//                     onSelected: (String category) {
//                       newsProvider.updateCategory(category);
//                     },
//                     color: ColorsConst.whiteColor,
//                     elevation: 1,
//                     itemBuilder: (BuildContext context) {
//                       return [
//                         const PopupMenuItem(
//                           value: 'business',
//                           child: Text('Business News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'entertainment',
//                           child: Text('Entertainment News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'general',
//                           child: Text('General News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'health',
//                           child: Text('Health News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'science',
//                           child: Text('Science News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'sports',
//                           child: Text('Sports News'),
//                         ),
//                         const PopupMenuItem(
//                           value: 'technology',
//                           child: Text('Technology News'),
//                         ),
//                       ];
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: Consumer<NewsProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading && provider.articles.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             } else {
//               List<Articles> articles = provider.articles;
//               articles.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
//               return ListView.builder(
//                 controller: _scrollController,
//                 itemCount: articles.length + (provider.isLoadingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == articles.length) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   DateTime lastUpdatedDate =
//                   DateTime.parse(articles[index].publishedAt.toString());
//                   String formattedDate =
//                   DateFormat('dd MMM yyyy hh:mm a').format(lastUpdatedDate);
//                   bool isSaved = isCoinSaved(articles[index]);
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 16, right: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => NewsAllDetailScreen(
//                                   newsArticle: articles[index],
//                                 ),
//                               ),
//                             );
//                           },
//                           child: ListTile(
//                             leading: SizedBox(
//                               height: 80,
//                               width: 100,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: articles[index].urlToImage != null
//                                     ? Image.network(
//                                   articles[index].urlToImage!,
//                                   fit: BoxFit.cover,
//                                 )
//                                     : Container(
//                                   color: ColorsConst.whiteColor,
//                                   child: Center(
//                                       child: Image.network(
//                                           StringConst.comingSoonImage)),
//                                 ),
//                               ),
//                             ),
//                             title: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   articles[index].title ?? '',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       articles[index].source?.name.toString() ??
//                                           '',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const Spacer(),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         if (isSaved) {
//                                           removeCoin(articles[index]);
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                               content: Text(StringConst
//                                                   .coinRemoved)));
//                                         } else {
//                                           saveCoin(articles[index]);
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(const SnackBar(
//                                               content: Text(StringConst
//                                                   .coinBookMarks)));
//                                         }
//                                         setState(() {
//                                           isSaved = !isSaved;
//                                         });
//                                       },
//                                       child: Icon(isSaved
//                                           ? Icons.bookmark
//                                           : Icons.bookmark_border_outlined),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   formattedDate,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Divider(),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   bool isCoinSaved(Articles article) {
//     final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
//     if (bookmarkedNews != null) {
//       final List<Articles> bookmarkedArticles = bookmarkedNews
//           .map((jsonString) => Articles.fromJson(json.decode(jsonString)))
//           .toList();
//       return bookmarkedArticles.any((savedArticle) => savedArticle.title == article.title);
//     }
//     return false;
//   }
//
//   void saveCoin(Articles article) {
//     final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
//     if (bookmarkedNews != null) {
//       bookmarkedNews.add(json.encode(article.toJson()));
//       newsProvider.prefs?.setStringList('bookmarkedNews', bookmarkedNews);
//     } else {
//       newsProvider.prefs?.setStringList('bookmarkedNews', [json.encode(article.toJson())]);
//     }
//   }
//
//   void removeCoin(Articles article) {
//     final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
//     if (bookmarkedNews != null) {
//       bookmarkedNews.removeWhere((jsonString) {
//         final savedArticle = Articles.fromJson(json.decode(jsonString));
//         return savedArticle.title == article.title;
//       });
//       newsProvider.prefs?.setStringList('bookmarkedNews', bookmarkedNews);
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/provider/news_provider.dart';
import 'package:saasaki_news_app/news/ui/bookmark_news_screen.dart';
import 'package:saasaki_news_app/news/ui/news_all_detail_screen.dart';
import 'package:saasaki_news_app/news/utils/colors_const.dart';
import 'package:saasaki_news_app/news/utils/string_const.dart';

class NewsInformationScreen extends StatefulWidget {
  const NewsInformationScreen({super.key});

  @override
  NewsScreen createState() => NewsScreen();
}

class NewsScreen extends State<NewsInformationScreen> {
  late NewsProvider newsProvider;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchNews();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 10 && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      newsProvider.fetchMoreNews().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: ColorsConst.whiteColor,
      ),
      child: Scaffold(
        backgroundColor: ColorsConst.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorsConst.blueColor,
          automaticallyImplyLeading: false,
          title: Text(
            '${newsProvider.selectedCategory[0].toUpperCase()}${newsProvider.selectedCategory.substring(1)} News',
            style: const TextStyle(color: Colors.white),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const BookMarkNewsScreen()));
                    },
                    icon: const Icon(
                      Icons.save,
                      color: ColorsConst.whiteColor,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.filter_list_rounded,
                      color: ColorsConst.whiteColor,
                    ),
                    onSelected: (String category) {
                      newsProvider.updateCategory(category);
                      setState(() {}); // Update the UI
                    },
                    color: ColorsConst.whiteColor,
                    elevation: 1,
                    itemBuilder: (BuildContext context) {
                      return [
                        buildMenuItem('business', 'Business News'),
                        buildMenuItem('entertainment', 'Entertainment News'),
                        buildMenuItem('general', 'General News'),
                        buildMenuItem('health', 'Health News'),
                        buildMenuItem('science', 'Science News'),
                        buildMenuItem('sports', 'Sports News'),
                        buildMenuItem('technology', 'Technology News'),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.articles.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<Articles> articles = provider.articles;
              articles.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
              return ListView.builder(
                controller: _scrollController,
                itemCount: articles.length + (provider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == articles.length) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  DateTime lastUpdatedDate =
                  DateTime.parse(articles[index].publishedAt.toString());
                  String formattedDate =
                  DateFormat('dd MMM yyyy hh:mm a').format(lastUpdatedDate);
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsAllDetailScreen(
                                  newsArticle: articles[index],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 80,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: articles[index].urlToImage != null
                                    ? Image.network(
                                  articles[index].urlToImage!,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  color: ColorsConst.whiteColor,
                                  child: Center(
                                    child: Image.network(
                                      StringConst.comingSoonImage,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  articles[index].title ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  articles[index].source?.name.toString() ??
                                      '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        if (isArticleBookmarked(
                                            articles[index])) {
                                          removeBookmark(articles[index]);
                                        } else {
                                          addBookmark(articles[index]);
                                        }
                                        setState(() {}); // Update the UI
                                      },
                                      child: Icon(
                                        isArticleBookmarked(articles[index])
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  PopupMenuItem<String> buildMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        text,
        style: TextStyle(
          color: newsProvider.selectedCategory == value
              ? ColorsConst.blueColor
              : Colors.black,
        ),
      ),
    );
  }

  bool isArticleBookmarked(Articles article) {
    final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
    if (bookmarkedNews != null) {
      final List<Articles> bookmarkedArticles = bookmarkedNews
          .map((jsonString) => Articles.fromJson(json.decode(jsonString)))
          .toList();
      return bookmarkedArticles
          .any((savedArticle) => savedArticle.title == article.title);
    }
    return false;
  }

  void addBookmark(Articles article) {
    final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
    if (bookmarkedNews != null) {
      bookmarkedNews.add(json.encode(article.toJson()));
      newsProvider.prefs?.setStringList('bookmarkedNews', bookmarkedNews);
    } else {
      newsProvider.prefs
          ?.setStringList('bookmarkedNews', [json.encode(article.toJson())]);
    }
  }

  void removeBookmark(Articles article) {
    final bookmarkedNews = newsProvider.prefs?.getStringList('bookmarkedNews');
    if (bookmarkedNews != null) {
      bookmarkedNews.removeWhere((jsonString) {
        final savedArticle = Articles.fromJson(json.decode(jsonString));
        return savedArticle.title == article.title;
      });
      newsProvider.prefs?.setStringList('bookmarkedNews', bookmarkedNews);
    }
  }
}
