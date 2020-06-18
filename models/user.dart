import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String username;
  final String userImage;
  final Map<String, dynamic> lastMessage;
  final Map<String, dynamic> read;
  final Map<String, dynamic> sent;

  User({
    this.id,
    this.email,
    this.username,
    this.userImage,
    this.lastMessage,
    this.read,
    this.sent,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc['email'],
      username: doc['username'],
      userImage: doc['profile_image_url'],
      lastMessage: doc['lastMessage'],
      read: doc['read'],
      sent: doc['sent'],
    );
  }
}
