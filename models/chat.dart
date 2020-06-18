import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String senderId;
  final String toUserId;
  final String username;
  final String text;
  final String userImage;
  final int type;
  final Timestamp createdAt;
  final bool sent;
  final bool read;

  Chat({
    this.id,
    this.senderId,
    this.toUserId,
    this.username,
    this.text,
    this.userImage,
    this.type,
    this.createdAt,
    this.sent,
    this.read,
  });

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
      id: doc.documentID,
      senderId: doc['senderId'],
      toUserId: doc['toUserId'],
      username: doc['username'],
      text: doc['text'],
      userImage: doc['userImage'],
      type: doc['type'],
      createdAt: doc['createdAt'],
      sent: doc['sent'],
      read: doc['read'],
    );
  }
}
