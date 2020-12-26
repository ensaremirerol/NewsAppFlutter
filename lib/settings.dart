import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:news_app/main.dart';
import 'package:news_app/news_sources.dart';
import 'package:news_app/services/rss_feed.dart';
import 'package:news_app/services/theme_manager.dart';
import 'package:news_app/utils/utils.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String sourceName = Rss.instance.source.name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Renk şeması"),
            subtitle: ThemeManager.instance.getTheme() ==
                    ThemeManager.instance.lightTheme
                ? Text("Açık tema")
                : Text("Karanlık tema"),
            trailing: Switch(
              value: ThemeManager.instance.getTheme() ==
                  ThemeManager.instance.lightTheme,
              onChanged: (value) => ThemeManager.instance.switchTheme(),
              activeColor: Colors.indigoAccent,
            ),
          ),
          ListTile(
              title: Text("Haber kaynağı"),
              subtitle: Text(sourceName),
              onTap: () => showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor:
                        ThemeManager.instance.getTheme().dividerColor,
                    builder: (context) => SourceSelector(
                      notifyParent: refresh,
                    ),
                  )),
          ListTile(
            title: Text("Hesaptan çık"),
            trailing: Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Utils.pushAndRemove(context, Splash());
            },
          ),
          ListTile(
            title: Text("Lisanslar"),
            trailing: Icon(Icons.book),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {
      sourceName = Rss.instance.source.name;
    });
  }
}

class SourceSelector extends StatelessWidget {
  final Function notifyParent;
  const SourceSelector({Key key, @required this.notifyParent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (MyRssSource source in sources)
            _builder(context, source.name, source.key)
        ],
      ),
    ));
  }

  ListTile _builder(BuildContext context, String name, String key) {
    return ListTile(
      title: Text(name),
      trailing: key == Rss.instance.source.key ? Icon(Icons.check) : null,
      onTap: () async {
        Rss.changeSource(key);
        await Rss.initRss();
        Navigator.of(context).pop();
        notifyParent();
      },
    );
  }
}
