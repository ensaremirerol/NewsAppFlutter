import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/auth_selector.dart';
import 'package:news_app/news.dart';
import 'package:news_app/services/rss_feed.dart';
import 'package:news_app/services/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Tema için bir singelton obje oluşturur
  ThemeManager.initThemeManager();
  // Bu şekilde ThemeManagerın değişiklikleri dinlenir
  runApp(ChangeNotifierProvider<ThemeManager>(
    create: (_) => ThemeManager.instance,
    child: Splash(),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    // Consumer widgetı ThemeManagerdaki değişikliklerin arayüze yansımasını sağlar
    return Consumer<ThemeManager>(
        builder: (_, themeData, __) => MaterialApp(
              theme: themeData.getTheme(),
              home: SplashScreen(
                image: Image.asset(
                  "assets/icons/icons8-news-512.png",
                ),
                title: Text(
                  "Haber Uygulaması",
                  style: TextStyle(fontSize: 25),
                ),
                photoSize: 100,
                backgroundColor: themeData.getTheme().backgroundColor,
                navigateAfterFuture: _route(),
              ),
            ));
  }

  // Eğerki hali hazırda kullanıcı girişi var ise Rss i init leyip
  // Haberler ekranına geçer
  // Kullanıcı girişi yok ise 3sn bekleyip Giriş ekranına geçer
  Future<StatefulWidget> _route() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await Rss.initRss();
      return News();
    }
    await Future.delayed(Duration(seconds: 3));
    return AuthSelector();
  }
}
