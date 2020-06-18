import 'package:UjikChat/models/user.dart';
import 'package:UjikChat/widgets/home/recent_message_list.dart';

import 'package:flutter/material.dart';

class RecentMessageItem extends StatelessWidget {
  final Stream<List<User>> allUserData;
  final String currentUserId;

  RecentMessageItem(this.allUserData, this.currentUserId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allUserData,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: userSnapshot.data.length,
            itemBuilder: (ctx, i) {
              return RecentMessageList(
                userSnapshot.data[i].username,
                userSnapshot.data[i].userImage,
                userSnapshot.data[i].lastMessage[currentUserId] ?? 'no message yet',
                userSnapshot.data[i].read[currentUserId],
                userSnapshot.data[i].sent[currentUserId],        
                userSnapshot.data[i].id == currentUserId,
                userSnapshot.data[i].id,
                currentUserId,          
              );
            });
      }
    );
  }
}
