class MyRssSource {
  final String url;
  final String name;
  final String key;

  MyRssSource(this.name, this.key, this.url);
}

final List<MyRssSource> sources = <MyRssSource>[
  MyRssSource("Anadolu Ajansı", "anadolu",
      "https://www.aa.com.tr/tr/rss/default?cat=guncel"),
  MyRssSource(
      "Hürriyet", "hurriyet", "https://www.hurriyet.com.tr/rss/anasayfa"),
  MyRssSource("T24", "t24", "https://t24.com.tr/rss")
];
