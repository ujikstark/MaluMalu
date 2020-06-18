import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  static const routeName = 'view-image';

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  String username;
  String userImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    username = routeArgs['username'];
    userImage = routeArgs['userImage'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(username),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(userImage),
                fit: BoxFit.fitWidth),
          ),
        )));
  }
}
