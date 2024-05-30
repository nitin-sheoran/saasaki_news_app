import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/ui/news_all_detail_screen.dart';
import 'package:saasaki_news_app/news/utils/colors_const.dart';
import 'package:saasaki_news_app/news/utils/string_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkNewsScreen extends StatefulWidget {
  const BookMarkNewsScreen({super.key});

  @override
  BookMarkCoinsScreenState createState() => BookMarkCoinsScreenState();
}

class BookMarkCoinsScreenState extends State<BookMarkNewsScreen> {
  List<Articles> articlesList = [];

  @override
  void initState() {
    super.initState();
    loadSavedCoins();
  }

  void loadSavedCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCoinsJson = prefs.getStringList(StringConst.savedCoinsKey);
    if (savedCoinsJson != null) {
      setState(() {
        articlesList = savedCoinsJson
            .map((json) => Articles.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -6,
        title: Text(
          StringConst.bookMarksCoins,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        )),
      ),
      body: articlesList.isEmpty
          ?  Center(
              child: Text(
                StringConst.noBookMarksCoins,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: articlesList.length,
              itemBuilder: (context, index) {
                Articles articles = articlesList[index];
                return
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewsAllDetailScreen(
                                  newsArticle: articles,)),
                      );
                    },
                    child: ListTile(
                      leading: SizedBox(
                        height: 80,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: articles.urlToImage != null
                              ? Image.network(
                            articles.urlToImage!,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: ColorsConst.whiteColor,
                            child: Center(
                                child: Image.network(
                                    StringConst.comingSoonImage)),
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articles.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            articles.source?.name.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
              },
            ),
    );
  }

  String formatMarketCap(num marketCap) {
    final units = ["", "K", "M", "B", "T"];
    int scale = 0;
    while (marketCap >= 1000 && scale < units.length - 1) {
      marketCap /= 1000;
      scale++;
    }
    final formattedValue = marketCap.toStringAsFixed(3);
    String trimmedValue = formattedValue.replaceAll(RegExp(r'\.?0+$'), '');
    trimmedValue += units[scale];
    return trimmedValue;
  }

  void removeSavedCoin(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCoinsJson = prefs.getStringList(StringConst.savedCoinsKey);
    if (savedCoinsJson != null) {
      savedCoinsJson.removeAt(index);
      prefs.setStringList(StringConst.savedCoinsKey, savedCoinsJson);
      setState(() {
        articlesList.removeAt(index);
      });
    }
  }
}

