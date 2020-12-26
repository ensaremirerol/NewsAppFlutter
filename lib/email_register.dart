import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:news_app/main.dart';
import 'package:news_app/templates/email-input.dart';
import 'package:news_app/utils/utils.dart';

class EmailRegister extends StatefulWidget {
  @override
  _EmailRegisterState createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("E-mail ile kayıt ol"),
        ),
        body: EmailInput(context, _emailController, _passwordController,
            _formKey, "Giriş Yap", _register));
  }

  Future<void> _register() async {
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .catchError((e) {
      switch (e.code) {
        case "weak-password":
          Utils.showFlushBar(context, "Şifreniz zayıf"); // Açıkla
          break;
        case "email-already-in-use":
          Utils.showFlushBar(context, "Email hali hazırda kullanımda");
          break;
        default:
          Utils.showFlushBar(context, "Bir hata oluştu ${e.message}");
          break;
      }
    });
    if (_auth.currentUser != null) {
      Utils.pushAndRemove(context, Splash());
    }
  }
}
