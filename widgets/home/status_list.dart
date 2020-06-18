import 'package:flutter/material.dart';

class StatusList extends StatelessWidget {
  final String username;
  final String userImage;

  StatusList(this.username, this.userImage);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green,
        ),
        title: Text('My Status'),
        subtitle: Text('Tap to add status update'),
      ),
      Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey,
          child: Text('Recent updates')),
      ListTile(
        leading:
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(userImage)),
        title: Text(username),
        subtitle: Text('10:00 AM'),
      ),
    ]);
  }
}
