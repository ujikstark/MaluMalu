import 'package:UjikChat/models/chat.dart';
import 'package:flutter/material.dart';

import 'package:UjikChat/widgets/chats/message_buble.dart';

class Messages extends StatelessWidget {
  final Stream<List<Chat>> allChats;
  final String currentUserId;
  final String groupChatId;
  final String receiverId;

  Messages(this.allChats, this.currentUserId, this.groupChatId, this.receiverId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: allChats,
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (chatSnapshot.data.length == 0) {
            return Center(
              child: Text('no message yet. start adding a new message'),
            );
          }
          return ListView.builder(
              reverse: true,
              itemCount: chatSnapshot.data.length,
              itemBuilder: (ctx, index) {           
                return MessageBuble(
                  chatSnapshot.data[index].username,
                  chatSnapshot.data[index].text,
                  chatSnapshot.data[index].type,
                  chatSnapshot.data[index].userImage,
                  chatSnapshot.data[index].createdAt.toDate(),
                  chatSnapshot.data[index].senderId == currentUserId,
                  chatSnapshot.data[index].id,
                  chatSnapshot.data[index].read,
                  chatSnapshot.data[index].sent,
                  groupChatId,
                  receiverId,
                  currentUserId,
                  key: ValueKey(chatSnapshot.data[index].id),
                );
              });
        });
  }
}
