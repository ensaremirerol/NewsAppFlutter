import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
              inactiveThumbColor: Colors.blueGrey,
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
            subtitle: Text(FirebaseAuth.instance.currentUser.displayName ??
                FirebaseAuth.instance.currentUser.email),
            trailing: Icon(Icons.logout),
            onTap: () async {
              if (FirebaseAuth
                      .instance.currentUser.providerData[0].providerId ==
                  "google.com") {
                await GoogleSignIn().signOut();
              }
              await FirebaseAuth.instance.signOut();
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
        color: ThemeManager.themeData == ThemeManager.instance.lightTheme
            ? Colors.white
            : Colors.black.withAlpha(100),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    "assets/icons/icons8-news-512.png",
                    scale: 5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Haber Uygulaması",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Bu uygulama Ensar Emir EROL tarafından Flutter ile yapılmıştır",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    "Lisanslar",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () => showLicensePage(
                      context: context,
                      applicationName: "Haber Uygulaması",
                      applicationVersion: "1.0",
                      applicationIcon: Image.asset(
                        "assets/icons/icons8-news-512.png",
                        scale: 5,
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
