import 'package:UjikChat/helpers/constants.dart';
import 'package:UjikChat/models/chat.dart';
import 'package:UjikChat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseServices {
  Stream<List<User>> streamUsers(String currentUserId) {
    return usersRef
        .snapshots()
        .map((list) => list.documents.map((doc) => User.fromDoc(doc)).toList());
  }

  Stream<List<Chat>> streamChats(String groupChatId) {
    return chatsRef
        .document(groupChatId)
        .collection(groupChatId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((list) => list.documents.map((doc) => Chat.fromDoc(doc)).toList());
  }

  Future<void> sendMessage(String text, int type, String currentUserId,
      String receiverId, String groupChatId) async {
    final userData = await usersRef.document(currentUserId).get();
    chatsRef.document(groupChatId).collection(groupChatId).add(
      {
        'text': text,
        'createdAt': Timestamp.now(),
        'senderId': currentUserId,
        'toUserId': receiverId,
        'username': userData['username'],
        'userImage': userData['profile_image_url'],
        'read': false,
        'sent': true,
        'type': type,
      },
    );
    if (userData['lastMessage'] != null) {
      usersRef.document(currentUserId).setData(
        {
          'lastMessage': {
            receiverId: text,
          },
          'read': {
            receiverId: false,
          },
          'sent': {
            receiverId: false,
          }
        },
        merge: true,
      );
      usersRef.document(receiverId).setData(
        {
          'lastMessage': {
            currentUserId: text,
          },
          'read': {
            currentUserId: false,
          },
          'sent': {
            currentUserId: true,
          }
        },
        merge: true,
      );
      print('data diupdate');
    } else {
      usersRef.document(currentUserId).updateData(
        {
          'lastMessage': {
            receiverId: text,
          },
          'read': {
            receiverId: false,
          },
          'sent': {
            receiverId: false,
          }
        },
      );
      usersRef.document(receiverId).updateData(
        {
          'lastMessage': {
            currentUserId: text,
          },
          'read': {
            currentUserId: false,
          },
          'sent': {
            currentUserId: true,
          }
        },
      );

      print('data ditambahkan');
    }
  }

  Future<void> sendImage(ImageSource source, String currentUserId,
      String receiverId, String groupChatId) async {
    final dateTimeNow = DateTime.now().toIso8601String();
    final pickedImage =
        await ImagePicker.pickImage(source: source, imageQuality: 60);
    final ref = storageRef.child('chatImage').child(dateTimeNow + '.jpg');
    await ref.putFile(pickedImage).onComplete;
    final imageFromChatUrl = await ref.getDownloadURL();
    print('gambar terkirim ke storage' + imageFromChatUrl);
    sendMessage(imageFromChatUrl, 1, currentUserId, receiverId, groupChatId);
  }

  Future<void> deleteMessage(String groupChatId, String documentId,
      String currentUserId, String receiverId) async {
    final userData = await usersRef.document(currentUserId).get();
    chatsRef
        .document(groupChatId)
        .collection(groupChatId)
        .document(documentId)
        .setData(
      {
        'text': '~]!,,)fjialwjfilawfjilhfilhfwlih232', // garbage character
      },
      merge: true,
    );
    if (userData['lastMessage'] != null) {
      usersRef.document(currentUserId).setData(
        {
          'lastMessage': {
            receiverId: '~]!,,)fjialwjfilawfjilhfilhfwlih232',
          },
        },
        merge: true,
      );
      usersRef.document(receiverId).setData(
        {
          'lastMessage': {
            currentUserId: '~]!,,)fjialwjfilawfjilhfilhfwlih232',
          },
        },
        merge: true,
      );
    } else {
      usersRef.document(currentUserId).updateData(
        {
          'lastMessage': {
            receiverId: '~]!,,)fjialwjfilawfjilhfilhfwlih232',
          },
        },
      );
      usersRef.document(receiverId).setData(
        {
          'lastMessage': {
            currentUserId: '~]!,,)fjialwjfilawfjilhfilhfwlih232',
          },
        },
        merge: true,
      );
    }
  }

  Future<void> changeReadValueReceiver(
    String currentUserId,
    String receiverId,
    String groupChatId,
  ) async {
    final userData = await usersRef.document(receiverId).get();
    final chatData = await chatsRef
        .document(groupChatId)
        .collection(groupChatId)
        .getDocuments();

    if (userData['read'] != null) {
      usersRef.document(currentUserId).setData(
        {
          'read': {
            receiverId: true,
          },
        },
        merge: true,
      );
      // yg baru
      usersRef.document(receiverId).setData(
        {
          'read': {
            currentUserId: true,
          },
        },
        merge: true,
      );
      chatData.documents.forEach(
        (doc) {
          doc.reference.setData(
            {
              'read': true,
            },
            merge: true,
          );
        },
      );
      print('data diupdate');
    } else {
      usersRef.document(currentUserId).updateData(
        {
          'read': {
            receiverId: true,
          },
        },
      );
      // yg baru
      usersRef.document(receiverId).updateData(
        {
          'read': {
            currentUserId: true,
          },
        },
      );
      chatData.documents.forEach(
        (doc) {
          doc.reference.updateData(
            {
              'read': true,
            },
          );
        },
      );
      print('data ditambahkan');
    }
  }
}
