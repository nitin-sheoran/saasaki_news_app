import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/provider/news_provider.dart';
import 'package:saasaki_news_app/news/ui/favorite_news_screen.dart';
import 'package:saasaki_news_app/news/ui/news_all_detail_screen.dart';
import 'package:saasaki_news_app/news/utils/colors_const.dart';
import 'package:saasaki_news_app/news/utils/string_const.dart';

class NewsInformationScreen extends StatefulWidget {
  const NewsInformationScreen({super.key});

  @override
  _NewsInformationScreen createState() => _NewsInformationScreen();
}

class _NewsInformationScreen extends State<NewsInformationScreen> {
  late NewsProvider newsProvider;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchNews();
    newsProvider.initSharedPreferences();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        newsProvider.fetchMoreNews();
      }
    });
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
          title: newsProvider.isSearching
              ? Container(
            child: TextFormField(
              autofocus: true,
              cursorColor: ColorsConst.whiteColor,
              cursorHeight: 22,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search...',
                hintStyle:
                const TextStyle(color: ColorsConst.white54Color),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: ColorsConst.whiteColor),
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: ColorsConst.whiteColor),
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                setState(() {
                  newsProvider.searchQuery = query;
                });
              },
            ),
          )
              : Text(
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
              padding: const EdgeInsets.only(right: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      newsProvider.isSearching ? Icons.close : Icons.search,
                      color: ColorsConst.whiteColor,
                    ),
                    onPressed: () {
                      setState(() {
                        newsProvider.isSearching = !newsProvider.isSearching;
                        newsProvider.searchQuery = '';
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const FavoriteNewsScreen()));
                    },
                    child: const Icon(
                      Icons.favorite,
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
              if (newsProvider.searchQuery.isNotEmpty) {
                articles = articles.where((article) {
                  return article.title!
                      .toLowerCase()
                      .contains(newsProvider.searchQuery.toLowerCase());
                }).toList();
              }
              articles.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
              return ListView.builder(
                controller: _scrollController,
                itemCount: articles.length + 1,
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
                    padding: const EdgeInsets.only(left: 14, right: 14),
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
                            contentPadding: EdgeInsets.zero,
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
                                  articles[index].source?.name.toString() ?? '',
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
                                        provider.toggleFavorite(articles[index].title ?? '');

                                      },
                                      child: Icon(
                                        provider.isFavorite(articles[index].title ?? '')
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: provider.isFavorite(articles[index].title ?? '')
                                            ? ColorsConst.redColor
                                            : ColorsConst.gray800Color,
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
}


// class _NewsInformationScreen extends State<NewsInformationScreen> {
//   late NewsProvider newsProvider;
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     newsProvider = Provider.of<NewsProvider>(context, listen: false);
//     newsProvider.fetchNews();
//     newsProvider.initSharedPreferences();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         newsProvider.loadMoreNews();
//       }
//     });
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
//         body: Consumer<NewsProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading && provider.articles.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             } else {
//               List<Articles> articles = provider.articles;
//               if (newsProvider.searchQuery.isNotEmpty) {
//                 articles = articles.where((article) {
//                   return article.title!
//                       .toLowerCase()
//                       .contains(newsProvider.searchQuery.toLowerCase());
//                 }).toList();
//               }
//               articles.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
//               return ListView.builder(
//                 controller: _scrollController,
//                 itemCount: articles.length + 1,
//                 itemBuilder: (context, index) {
//                   if (index == articles.length) {
//                     return const Padding(
//                       padding: EdgeInsets.only(bottom: 20),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                   DateTime lastUpdatedDate =
//                   DateTime.parse(articles[index].publishedAt.toString());
//                   String formattedDate =
//                   DateFormat('dd MMM yyyy hh:mm a').format(lastUpdatedDate);
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 14, right: 14),
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
//                             contentPadding: EdgeInsets.zero,
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
//                                     child: Image.network(
//                                       StringConst.comingSoonImage,
//                                     ),
//                                   ),
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
// }
