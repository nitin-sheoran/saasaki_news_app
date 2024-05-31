import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saasaki_news_app/news/model/news_model.dart';
import 'package:saasaki_news_app/news/utils/colors_const.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsAllDetailScreen extends StatefulWidget {
  const NewsAllDetailScreen({required this.newsArticle, super.key});

  final Articles newsArticle;

  @override
  State<NewsAllDetailScreen> createState() => _NewsAllDetailScreenState();
}

class _NewsAllDetailScreenState extends State<NewsAllDetailScreen> {
  Future<void> _launchURL() async {
    final uri = Uri.parse(widget.newsArticle.url.toString());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${widget.newsArticle.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastUpdatedDate =
        DateTime.parse(widget.newsArticle.publishedAt.toString());
    String formattedDate =
        DateFormat('dd MMM yyyy hh:mm a').format(lastUpdatedDate);
    return Scaffold(
      backgroundColor: ColorsConst.whiteColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.blueColor,
        titleSpacing: -8,
        title: const Text(
          'News Details',
          style: TextStyle(color: Colors.white),
        ),
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: widget.newsArticle.urlToImage != null
                      ? Image.network(
                          widget.newsArticle.urlToImage ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          color: ColorsConst.whiteColor,
                          child: Center(
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9b7ve9oIilsA8oz5bbsrKZvAe2oT7ESuFKKUO3eHWRL0LEnOQnzz4lRHYAg&s',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: const TextStyle(
                    fontSize: 16, color: ColorsConst.blackColor),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _launchURL,
                child: Text(
                  widget.newsArticle.url ?? 'Unknown Url',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.newsArticle.title ?? 'Unknown Title',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.newsArticle.description ?? 'Unknown Description',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.newsArticle.content ?? 'Unknown Content',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.newsArticle.author ?? 'Unknown Author',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat('MMM dd, yyyy').format(dateTime);
    return formattedTime;
  }
}
