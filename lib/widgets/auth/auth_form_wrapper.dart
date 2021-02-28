import 'dart:io';

import 'package:bartender/widgets/auth/auth_form.dart';
import 'package:bartender/providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class AuthFormWrapper extends StatefulWidget {
  AuthFormWrapper();

  @override
  _AuthFormWrapperState createState() => _AuthFormWrapperState();
}

class _AuthFormWrapperState extends State<AuthFormWrapper> {

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      final provider = Provider.of<Auth>(context, listen: false);
      if (isLogin) {
        await provider.login(email, password);
        // handle login success & failure
        
      } else {
        await provider.signup(username, email, password, image);
      }      
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context); 
    return FutureBuilder(
        future: provider.authInit(),
        builder: (ctx, snapshot) {
          print(provider.isLoggedIn);
          // print(provider.collections);
          return AuthForm(_submitAuthForm, false);
        }
      );
  }
}