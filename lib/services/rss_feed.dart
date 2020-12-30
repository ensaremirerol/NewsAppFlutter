import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

import '../news_sources.dart';
import 'shared_preferences.dart';

class Rss {
  static Rss instance;
  MyRssSource source; // Haber kaynağı
  bool sourceChanged; // Kaynak değişti mi?
  // Kaynağın itemlarından toplanan Kategoriler
  // Kategoriler kaynağa göre dinamik olarak oluşturulur
  List<RssCategory> categories = new List<RssCategory>();
  RssFeed feed;
  RssCategory currentCategory;
  Rss();

  // Cihazdan kaynak bilgisini okuyup nesneyi oluşturur
  static Future<void> initRss() async {
    instance = Rss();
    instance.sourceChanged = false;
    String key = await SharedPreferencesManager.readData('source');
    instance.source = sources.singleWhere((element) => element.key == key,
        orElse: () => sources[1]);
    List<RssItem> items = await getRssItems();
    for (RssItem item in items) {
      for (RssCategory category in item.categories) {
        if (instance.categories
            .where((element) => element.value == category.value)
            .toList()
            .isEmpty) {
          instance.categories.add(category);
        }
      }
    }
    instance.categories.sort((a, b) => a.value.compareTo(b.value));
  }

  // Rss itemlarını getirir
  static Future<List<RssItem>> getRssItems() async {
    if (instance == null) {
      await initRss();
    }
    var client = http.Client();

    var response = await client.get(instance.source.url);

    instance.feed = RssFeed.parse(response.body);

    return instance.currentCategory != null
        ? getItemsByCategory(instance.currentCategory, instance.feed.items)
        : instance.feed.items;
  }

  // Kategorileri getirir
  static Future<List<RssCategory>> getRssCategories() async {
    if (instance == null || instance.sourceChanged) {
      await initRss();
    }
    return instance.categories;
  }

  // Kaynağı değiştirir
  // Cihaz hafızasına yazar
  static void changeSource(String key) async {
    SharedPreferencesManager.saveData("source", key);
    instance.source = sources.singleWhere((element) => element.key == key);
    Rss.instance.sourceChanged = true;
  }

  // Seçilen kategoriye göre itemları filitreler
  static List<RssItem> getItemsByCategory(
      RssCategory category, List<RssItem> items) {
    if (category != null) {
      return items
          .where((element) =>
              element.categories.isNotEmpty &&
              element.categories[0].value == category.value)
          .toList();
    }
    return items;
  }

  // Verilen text e göre itemları filitreler
  static List<RssItem> searchRssItems(List<String> filters) {
    return filters != null && filters.isNotEmpty
        ? instance.feed.items.where((element) {
            for (String filter in filters) {
              if (!element.title.toLowerCase().contains(filter) &&
                  !(element.description != null &&
                      element.description.toLowerCase().contains(filter))) {
                return false;
              }
            }
            return true;
          }).toList()
        : instance.feed.items;
  }
}
