import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/chat/presentation/refactors/chat_body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    required this.chatId,
    required this.otherUser, super.key,
  });

  final String chatId;
  final UserModel otherUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.color.mainColor,
        elevation: 0,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.color.textColor,
          ),
        ),
       title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(otherUser.userImage.toString()),
            ),
            const SizedBox(width: 12),
            TextApp(
              text: otherUser.userName,
              theme: TextStyle(
                fontSize: 18,
                fontWeight: FontWeightHelper.bold,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
                color: context.color.textColor,
              ),
            ),
          ],
        )
       
//        StreamBuilder<DocumentSnapshot>(
//   stream: FirebaseFirestore.instance
//       .collection('chats')
//       .doc(chatId)
//       .snapshots(),
//   builder: (context, chatSnap) {
//     if (!chatSnap.hasData || !chatSnap.data!.exists) {
//       return TextApp(
//         text: 'Loading...',
//         theme: TextStyle(
//           fontSize: 16,
//           color: context.color.textColor,
//         ),
//       );
//     }

//     final chatData = chatSnap.data!.data() as Map<String, dynamic>? ?? {};

//     // participants لو مش موجودة أو null → ترجع ليست فاضية
//     final participants =
//         (chatData['participants'] as List?)?.map((e) => e.toString()).toList() ?? [];

//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     // لو الليست فاضية أو كلها نفس اليوزر الحالي
//     if (participants.isEmpty || participants.every((id) => id == currentUserId)) {
//       return TextApp(
//         text: 'No user found',
//         theme: TextStyle(
//           fontSize: 16,
//           color: context.color.textColor,
//         ),
//       );
//     }

//     // نجيب اليوزر التاني
//     final otherUserId = participants.firstWhere(
//       (id) => id != currentUserId,
//       orElse: () => '',
//     );

//     if (otherUserId.isEmpty) {
//       return TextApp(
//         text: 'No user found',
//         theme: TextStyle(
//           fontSize: 16,
//           color: context.color.textColor,
//         ),
//       );
//     }

//     // StreamBuilder خاص بالـ user
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(otherUserId)
//           .snapshots(),
//       builder: (context, userSnap) {
//         if (!userSnap.hasData || !userSnap.data!.exists) {
//           return TextApp(
//             text: 'Unknown User',
//             theme: TextStyle(
//               fontSize: 16,
//               color: context.color.textColor,
//             ),
//           );
//         }

//         final userData = userSnap.data!.data() as Map<String, dynamic>? ?? {};
//         final userName = userData['name'] ?? "No Name";
//         final userAvatar = userData['avatar'] ??
//             "https://ui-avatars.com/api/?name=$userName";

//         return Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage(userAvatar.toString()),
//             ),
//             const SizedBox(width: 12),
//             TextApp(
//               text: userName.toString(),
//               theme: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeightHelper.bold,
//                 fontFamily: FontFamilyHelper.cairoArabic,
//                 letterSpacing: 0.5,
//                 color: context.color.textColor,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   },
// ),


      ),
      body: ChatBody(chatId: chatId),
    );
  }
}
