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
            onTap: () => showMaterialModalBottomSheet(
                context: context, builder: (context) => AboutPage()),
          ),
        ],
      ),
    );
  }

  void refresh(String name) {
    setState(() {
      sourceName = name;
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
        Navigator.of(context).pop();
        notifyParent(name);
      },
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: Icon(Icons.flag),
              ),
              Text(
                "Haber Uygulaması",
                style: TextStyle(fontSize: 20),
              ),
              Divider(
                height: 20,
              ),
              Text(
                "Bu uygulama Ensar Emir EROL tarafından Flutter ile yapılmıştır",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: Text(
                  "Lisanslar",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () => showLicensePage(
                    context: context,
                    applicationName: "Haber Uygulaması",
                    applicationVersion: "1.0"),
              )
            ],
          ),
        ));
  }
}
