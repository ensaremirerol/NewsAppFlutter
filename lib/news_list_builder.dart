import 'package:flutter/material.dart';
import 'package:news_app/news_webview.dart';
import 'package:news_app/utils/utils.dart';
import 'package:webfeed/domain/rss_item.dart';

//
class NewsListBuilder extends StatelessWidget {
  final List<RssItem> items;
  NewsListBuilder({Key key, @required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, i) {
        RssItem _item = items[i];
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
          onTap: () => Utils.push(context, NewsWebview(_item.link)),
        );
      },
      separatorBuilder: (context, i) => Divider(),
      itemCount: items.length,
    );
  }
}
