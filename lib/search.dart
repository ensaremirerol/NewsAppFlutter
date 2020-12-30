import 'package:flutter/material.dart';
import 'package:news_app/news_list_builder.dart';
import 'package:news_app/services/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _filter = new TextEditingController();
  List<String> filters;
  _SearchState() {
    // _filter a listener ekleyerek Arama listesinin dinamik olması sağlanıyor
    _filter.addListener(() {
      setState(() {
        if (_filter.text.isEmpty && filters != null) {
          filters.clear();
        } else {
          filters = _filter.text.toLowerCase().split(" ");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<RssItem> result = Rss.searchRssItems(filters);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: TextField(
              autofocus: true,
              controller: _filter,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search), hintText: 'Ara...'),
            )),
        body: NewsListBuilder(
          items: result ?? [],
        ));
  }
}
