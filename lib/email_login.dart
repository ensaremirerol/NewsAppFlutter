import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:news_app/main.dart';
import 'package:news_app/templates/email-input.dart';
import 'package:news_app/utils/utils.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-mail ile giriş yap"),
      ),
      body: EmailInput(context, _emailController, _passwordController, _formKey,
          "Giriş Yap", _login),
    );
  }

  void _login() async {
    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .catchError((e) {
      switch (e.code) {
        case "invalid-email":
          Utils.showFlushBar(context, "Hatalı e posta");
          break;
        case "wrong-password":
          Utils.showFlushBar(context, "Hatalı şifre");
          break;
        case "too-many-requests":
          Utils.showFlushBar(context,
              "Çok fazla denemede bulundunuz. Lütfen biraz bekleyiniz");
          break;
        default:
          Utils.showFlushBar(context, "Bir hata oluştu  ${e.code}");
          break;
      }
    });
    if (_auth.currentUser != null) {
      Utils.pushAndRemove(context, Splash());
    }
  }
}
