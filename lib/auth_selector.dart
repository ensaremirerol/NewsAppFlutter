import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:news_app/email_login.dart';
import 'package:news_app/services/theme_manager.dart';

import 'email_register.dart';

class AuthSelector extends StatefulWidget {
  @override
  _AuthSelectorState createState() => _AuthSelectorState();
}

class _AuthSelectorState extends State<AuthSelector> {
  ThemeData themeData = ThemeManager.instance.getTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haber Uygulaması"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: SignInButtonBuilder(
              icon: Icons.person_add,
              backgroundColor: themeData.buttonColor,
              text: "Kayıt Ol",
              textColor: themeData.accentColor,
              iconColor: themeData.accentColor,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EmailRegister())),
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
          ),
          Container(
            child: SignInButtonBuilder(
              icon: Icons.login,
              backgroundColor: themeData.buttonColor,
              text: "Giriş yap",
              textColor: themeData.accentColor,
              iconColor: themeData.accentColor,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EmailLogin())),
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
          ),
          Container(
            child: SignInButtonBuilder(
              icon: Icons.login,
              backgroundColor: themeData.buttonColor,
              text: "Google ile Giriş yap",
              textColor: themeData.accentColor,
              iconColor: themeData.accentColor,
              onPressed: () => {},
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}