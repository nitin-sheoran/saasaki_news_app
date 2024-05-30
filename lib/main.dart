import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_news_app/news/provider/news_provider.dart';
import 'package:saasaki_news_app/news/service/news_service.dart';
import 'package:saasaki_news_app/news/ui/news_information_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                NewsProvider(newsApiService: NewsApiService())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const NewsInformationScreen(),
      ),
    );
  }
}
