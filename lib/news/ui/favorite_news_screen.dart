import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/provider/news_provider.dart';
import 'package:saasaki_news_app/news/ui/news_all_detail_screen.dart';
import 'package:saasaki_news_app/news/utils/colors_const.dart';
import 'package:saasaki_news_app/news/utils/string_const.dart';

class FavoriteNewsScreen extends StatefulWidget {
  const FavoriteNewsScreen({super.key});

  @override
  State<FavoriteNewsScreen> createState() => _FavoriteNewsScreenState();
}

class _FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  late NewsProvider newsProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.whiteColor,
      appBar: AppBar(
        titleSpacing: -6,
        title: const Text('Favorite News',style: TextStyle(color: ColorsConst.whiteColor),),
        backgroundColor: ColorsConst.blueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsConst.whiteColor,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            )),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          List<Articles> favoriteArticles = provider.getFavoriteArticles();

          if (favoriteArticles.isEmpty) {
            return const Center(child: Text('No favorite news...'));
          }

          return ListView.builder(
            itemCount: favoriteArticles.length,
            itemBuilder: (context, index) {
              DateTime lastUpdatedDate = DateTime.parse(
                  favoriteArticles[index].publishedAt.toString());
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
                              newsArticle: favoriteArticles[index],
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
                            child: favoriteArticles[index].urlToImage != null
                                ? Image.network(
                                    favoriteArticles[index].urlToImage!,
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
                              favoriteArticles[index].title ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              favoriteArticles[index].source?.name.toString() ??
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
                                    provider.toggleFavorite(
                                        favoriteArticles[index].title ?? '');

                                  },
                                  child: Icon(
                                    provider.isFavorite(
                                            favoriteArticles[index].title ?? '')
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: provider.isFavorite(
                                            favoriteArticles[index].title ?? '')
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
        },
      ),
    );
  }
}
