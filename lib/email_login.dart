import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:news_app/main.dart';
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

  bool _success = true;
  String _message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-mail ile giriş yap"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (String email) {
                    if (email.isEmpty) {
                      return "Lütfen bir mail giriniz";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Şifre"),
                  validator: (String password) {
                    if (password.isEmpty) {
                      return "Lütfen bir şifre giriniz";
                    }
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: SignInButtonBuilder(
                    icon: Icons.person_add,
                    backgroundColor: Colors.blueGrey,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await _login();
                        if (_auth.currentUser != null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Splash()));
                        }
                      }
                    },
                    text: "Giriş yap",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
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
  }
}
