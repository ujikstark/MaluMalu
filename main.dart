import 'package:UjikChat/models/user_data.dart';
import 'package:UjikChat/screens/home_screen.dart';
import 'package:UjikChat/services/database_services.dart';
import 'package:UjikChat/widgets/pickers/view_image.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:UjikChat/screens/auth_screen.dart';
import 'package:UjikChat/screens/chat_screen.dart';
import 'package:UjikChat/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(  
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        // Provider<AuthServices>(
        //   create: (_) => AuthServices(),
        // ),
        Provider<DatabaseServices>(
          create: (_) => DatabaseServices(),
        ),
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NekoChat',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.deepOrange,
        accentColor: Colors.lime,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.green,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.hasData) {
            Provider.of<UserData>(context, listen: false).currentUserId =
                userSnapshot.data.uid;
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        ChatScreen.routeName: (ctx) => ChatScreen(),
        ViewImage.routeName: (ctx) => ViewImage(),
      },
    );
  }
}
