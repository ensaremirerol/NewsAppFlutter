import 'package:flutter/material.dart';
import 'package:news_app/newListTile.dart';
import 'package:news_app/search.dart';
import 'package:news_app/services/rss_feed.dart';
import 'package:news_app/settings.dart';
import 'package:news_app/utils/utils.dart';
import 'package:webfeed/webfeed.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Rss.instance?.feed?.title ?? ""),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Utils.push(context, Settings())),
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Utils.push(context, Search()))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(Rss.instance.feed?.title ?? ""),
                    Text("Kategoriler")
                  ]),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              if (Rss.instance.categories != null)
                for (RssCategory category in Rss.instance.categories)
                  _buildDrawerList(category)
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
            future: Rss.getRssItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<RssItem> items = snapshot.data;
                return Test(
                  items: items,
                );
              } else if (snapshot.hasError) {
                return ListView(
                  children: [
                    ListTile(
                      title: Text(snapshot.error.toString()),
                    )
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  ListTile _buildDrawerList(RssCategory category) {
    return ListTile(
      title: Text(category.value),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          Rss.instance.currentCategory = category;
        });
      },
    );
  }

  Future<void> refresh() async {
    setState(() {
      Rss.instance.currentCategory = null;
    });
  }
}
