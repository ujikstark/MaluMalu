import 'package:UjikChat/models/user_data.dart';
import 'package:UjikChat/screens/chat_screen.dart';
import 'package:UjikChat/widgets/pickers/view_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:UjikChat/services/database_services.dart';
import 'package:provider/provider.dart';

class RecentMessageList extends StatelessWidget {
  final String username;
  final String userImage;
  final String lastMessage;
  final bool isRead;
  final bool sent;
  final bool isMe;
  final String receiverId;
  final String currentUserId;

  RecentMessageList(
    this.username,
    this.userImage,
    this.lastMessage,
    this.isRead,
    this.sent,
    this.isMe,
    this.receiverId,
    this.currentUserId,
  );
  @override
  Widget build(BuildContext context) {
    final String groupChatId =
        Provider.of<UserData>(context, listen: false).groupChatId;
    String deletedMessage =
        '~]!,,)fjialwjfilawfjilhfilhfwlih232'; // i identify deleted message as garbage character
    int messageNotReadYet = 0;
    if (!isMe)
      return Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
                'receiverId': receiverId,
                'currentUserId': currentUserId,
                'username': username,
                'userImage': userImage,
              });
              if (isRead == false && !isMe && sent == false)
                Provider.of<DatabaseServices>(context, listen: false)
                    .changeReadValueReceiver(
                        currentUserId, receiverId, groupChatId);
            },
            child: ListTile(
                leading: GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: Container(
                          width: 350,
                          height: 350,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ViewImage.routeName,
                                      arguments: {
                                        'username': username,
                                        'userImage': userImage,
                                      });
                                },
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          userImage,
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.message),
                                    onPressed: () {},
                                    color: Colors.deepOrange,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.call),
                                      onPressed: () {},
                                      color: Colors.deepOrange),
                                  IconButton(
                                      icon: Icon(Icons.videocam),
                                      onPressed: () {},
                                      color: Colors.deepOrange),
                                  IconButton(
                                      icon: Icon(Icons.perm_device_information),
                                      onPressed: () {},
                                      color: Colors.deepOrange)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: CachedNetworkImageProvider(userImage),
                  ),
                ),
                title: Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: (lastMessage.startsWith('http') &&
                        (lastMessage.startsWith('https'))
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (isRead == false &&
                              lastMessage != null &&
                              sent == true)
                            Text(''),
                          if (isRead == true &&
                              lastMessage != null &&
                              sent == true)
                            Icon(
                              Icons.done_all,
                              color: Colors.grey,
                              size: 18,
                            ),
                          if (isRead == false &&
                              lastMessage != null &&
                              sent == true)
                            Icon(
                              Icons.done_all,
                              color: Colors.blue,
                              size: 18,
                            ),
                          if (lastMessage == deletedMessage)
                            Text(
                              '⊗ You deleted this message',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (lastMessage == deletedMessage)
                            Text(
                              '⊗ this message was deleted',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Text('Photo')
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          if (isRead == false &&
                              lastMessage != null &&
                              sent == true)
                            Text(''),
                          if (isRead == true &&
                              lastMessage != null &&
                              sent == true)
                            Icon(
                              Icons.done_all,
                              color: Colors.blue,
                              size: 18,
                            ),
                          if (isRead == false &&
                              lastMessage != null &&
                              sent == true)
                            Icon(
                              Icons.done_all,
                              color: Colors.grey,
                              size: 18,
                            ),
                          if (lastMessage == deletedMessage &&
                              !isMe &&
                              sent == true)
                            Text(
                              '⊗ You deleted this message',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (lastMessage == deletedMessage && sent == false)
                            Text(
                              '⊗ this message was deleted',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          SizedBox(width: 5),
                          Expanded(
                            child: (lastMessage == deletedMessage)
                                ? Text('')
                                : Text(
                                    lastMessage,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                        ],
                      )),
                trailing:
                    (isRead == false && lastMessage != null && sent == false && !isMe)
                        ? Text(messageNotReadYet.toString())
                        : Text('')),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
            child: Divider(
              color: Colors.grey[300],
            ),
          ),
        ],
      );
    return Container();
  }
}
