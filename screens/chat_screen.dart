import 'package:UjikChat/models/user_data.dart';
import 'package:UjikChat/services/database_services.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:UjikChat/widgets/chats/messages.dart';
import 'package:UjikChat/widgets/chats/new_message.dart';
import 'package:UjikChat/models/chat.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String receiverId, username, userImage, currentUserId;
  Stream<List<Chat>> _chats;
  String _groupChatId = '';


  @override
  void didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    receiverId = routeArgs['receiverId'];
    currentUserId = routeArgs['currentUserId'];
    username = routeArgs['username'];
    userImage = routeArgs['userImage'];
    _getAllChats();
    Provider.of<UserData>(context, listen: false).groupChatId = _groupChatId;
    super.didChangeDependencies();
  }

  _getAllChats() {
    if (currentUserId.hashCode <= receiverId.hashCode) {
      _groupChatId = '$currentUserId-$receiverId';
    } else {
      _groupChatId = '$receiverId-$currentUserId';
    }
     
    Stream<List<Chat>> chats =
        Provider.of<DatabaseServices>(context, listen: false).streamChats(_groupChatId);
    if (mounted) {
      setState(() {
        _chats = chats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userImage),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/email-pattern.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              child: Messages(_chats, currentUserId, _groupChatId, receiverId),
            ),
            NewMessage(currentUserId, receiverId, _groupChatId),
          ],
        ),
      ),
    );
  }
}
