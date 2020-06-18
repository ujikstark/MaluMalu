import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MessageBuble extends StatelessWidget {
  final String username;
  final String message;
  final int type;
  final String profileUserImage;
  final DateTime dateTime;
  final bool isMe;
  final String documentId;
  final bool isRead;
  final bool sent;
  final String groupChatId;
  final String receiverId;
  final String currentUserId;
  final Key key;

  MessageBuble(
      this.username,
      this.message,
      this.type,
      this.profileUserImage,
      this.dateTime,
      this.isMe,
      this.documentId,
      this.isRead,
      this.sent,
      this.groupChatId,
      this.receiverId,
      this.currentUserId,
      {this.key});

  @override
  Widget build(BuildContext context) {
    String deletedMessage =
        '~]!,,)fjialwjfilawfjilhfilhfwlih232'; // i identify deleted message as garbage character
    // Provider.of<UserData>(context).chatDocumentId = lastChatDocumentId;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // if (!isMe)
        //   Padding(
        //     padding: const EdgeInsets.only(left: 8.0),
        //     child: CircleAvatar(
        //       backgroundImage: NetworkImage(profileUserImage),
        //     ),
        //   ),
        if (type == 2) Container(child: Image.asset(message)),
        GestureDetector(
          onLongPress: () {
            // Scaffold.of(context).showBottomSheet(
            //   (context) => Container(
            //     color: Colors.red,
            //     height: MediaQuery.of(context).size.height * 0.1,
            //     child: IconButton(
            //       icon: Icon(
            //         Icons.delete,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         if (isMe)
            //           Provider.of<DatabaseServices>(context, listen: false)
            //               .deleteMessage(groupChatId, documentId, currentUserId,
            //                   receiverId);
            //       },
            //     ),
            //   ),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
              border:
                  isMe ? null : Border.all(width: 1, color: Colors.grey[300]),
              color: isMe ? Colors.lime[200] : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if (!isMe)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 10.0),
                //     child: Text(
                //       '~$username',
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //   ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message == deletedMessage && isMe)
                      Text(
                        '⊗ You deleted this message',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (message == deletedMessage && !isMe)
                      Text(
                        '⊗ this message was deleted',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (type == 0 && message != deletedMessage)
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                    if (type == 1 && message != deletedMessage)
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: CachedNetworkImage(
                          imageUrl: message,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(dateTime),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      if (sent == true && isRead == false && isMe)
                        Icon(Icons.done_all, color: Colors.grey, size: 16),
                      if (sent == true && isRead == true && isMe)
                        Icon(Icons.done_all, color: Colors.blue, size: 16)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
