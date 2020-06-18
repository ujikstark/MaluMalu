// import 'package:UjikChat/widgets/home/status_list.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class StatusItem extends StatelessWidget {
//   final Stream<QuerySnapshot> userStream;

//   StatusItem(this.userStream);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: userStream,
//         builder: (context, userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return ListView.builder(
//               itemCount: userSnapshot.data.documents.length,
//               itemBuilder: (ctx, i) {
//                 return StatusList(
//                   userSnapshot.data.documents[i]['username'],
//                   userSnapshot.data.documents[i]['profile_image_url'],
//                 );
//               });
//         });
//   }
// }
