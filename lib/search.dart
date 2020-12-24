import 'package:flutter/material.dart';
import 'package:news_app/news_webview.dart';
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
    _filter.addListener(() {
      setState(() {
        if (_filter.text.isEmpty) {
          filters.clear();
        } else {
          filters = _filter.text.split(" ");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<RssItem> result = filters != null && filters.isNotEmpty
        ? Rss.instance.feed.items.where((element) {
            for (String filter in filters) {
              if (!element.title.toLowerCase().contains(filter) &&
                  !(element.description != null &&
                      element.description.toLowerCase().contains(filter))) {
                return false;
              }
            }
            return true;
          }).toList()
        : Rss.instance.feed?.items;
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: TextField(
              controller: _filter,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
            )),
        body: ListView.separated(
          itemBuilder: (context, i) {
            RssItem _item = result[i];
            return ListTile(
              title: Text(_item.title),
              subtitle: _item.description != null
                  ? Text(
                      _item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              leading: _item.enclosure != null
                  ? Image.network(_item.enclosure.url)
                  : null,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewsWebview(_item.link))),
            );
          },
          separatorBuilder: (context, i) => Divider(),
          itemCount: result.length,
        ));
  }
}
