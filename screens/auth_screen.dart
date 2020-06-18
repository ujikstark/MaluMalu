import 'dart:io';

import 'package:UjikChat/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:UjikChat/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // AuthServices _auth = AuthServices();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult _auth;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _auth = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _auth = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref =
            storageRef.child('user_image').child(_auth.user.uid + '.jpg');
        await ref.putFile(image).onComplete;
        final profileImageUrl = await ref.getDownloadURL();

        await usersRef.document(_auth.user.uid).setData(
          {
            'username': username,
            'email': email,
            'profile_image_url': profileImageUrl,
            'lastMessage': {},
            'read': {},
            'sent': {},
          },
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
