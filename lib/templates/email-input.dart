import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey;
  final String actionString;
  final Function actionFunction;
  EmailInput(
      BuildContext context,
      this._emailController,
      this._passwordController,
      this._formKey,
      this.actionString,
      this.actionFunction);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
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
                      await actionFunction();
                    }
                  },
                  text: actionString,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
